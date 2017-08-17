from datetime import datetime, timedelta
import json
import os
from tempfile import NamedTemporaryFile, TemporaryDirectory
import shutil
import time
import uuid

from airflow import DAG
from airflow.hooks.S3_hook import S3Hook
from airflow.operators.python_operator import PythonOperator
from airflow.operators.sensors import S3KeySensor

import paramiko

from git import Repo

import create_jobs

WORKFLOW_JOBS_GIT='git@github.com:NCI-GDC/workflow-jobs.git'

default_args = {
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'owner': 'airflow',
    'start_date': datetime.now() - timedelta(days=1),
}

dag = DAG('fastq-rnaseq-stats',
          default_args=default_args,
          schedule_interval=None
#          schedule_interval='@once'
)

sensor = S3KeySensor(
    task_id='check_s3',
    bucket_name = 'secure-east2-test-bucket',
    s3_host = 's3-us-east-2.amazonaws.com',
    bucket_key = 'jobs*.json',
    wildcard_match=True,
    s3_conn_id='fs_default',
    timeout=0,
    poke_interval=0,
    soft_fail=False,
    dag=dag)

def put_slurm_scripts(sftp, remotepath, localpath):
    os.chdir(os.path.split(localpath)[0])
    parent=os.path.split(localpath)[1]
    for walker in os.walk(parent):
        try:
            sftp.mkdir(os.path.join(remotepath,walker[0]))
        except:
            pass
        for file in walker[2]:
            sftp.put(os.path.join(walker[0],file),os.path.join(remotepath,walker[0],file))
    return

def rm_slurm_scripts(sftp, slurm_dir):
    remote_path_list = list()
    for remote_path in sftp.listdir_iter(slurm_dir):
        remote_path_list.append(remote_path)
    for remote_path in remote_path_list:
        if stat.S_ISDIR(remote_path.st_mode):
            remove_dir = os.path.join(slurm_dir, remote_path.filename)
            if len(sftp.listdir(remove_dir)) > 0:
                rm_slurm_scripts(sftp, remove_dir)
                sftp.rmdir(remove_dir)
            else:
                sftp.rmdir(remove_dir)
        else:
            remove_file = os.path.join(slurm_dir, remote_path.filename)
            sftp.remove(remove_file)
    return

def create_run_jobs(queue_json_file):
    with TemporaryDirectory() as temp_git_dir:
        # create jobs
        job_creation_uuid = str(uuid.uuid4())

        ## get job data
        with open(queue_json_file.name,'r') as f:
            f.seek(0)
            queue_dict = json.loads(f.read())

        ## make jobs in temp dir
        with TemporaryDirectory() as temp_job_dir:
            for queue_item in queue_dict:
                queue_item['job_creation_uuid'] = job_creation_uuid
                create_jobs.setup_job(queue_item, temp_job_dir)

            ## clone git repo
            repo_dir=os.path.join(temp_git_dir, os.path.basename(WORKFLOW_JOBS_GIT).split('.')[0])
            os.makedirs(repo_dir)
            git_repo = Repo.clone_from(WORKFLOW_JOBS_GIT, repo_dir)

            ## add new jobs to repo
            job_git_dir = os.path.join(repo_dir, job_creation_uuid)
            os.rename(os.path.join(temp_job_dir,job_creation_uuid), job_git_dir)
            git_repo.index.add([job_git_dir])
            git_repo.index.commit("airflow add jobs")
            origin = git_repo.remote(name='origin')
            origin.push()

            ## get list of slurm scripts
            git_slurm_dir = os.path.join(job_git_dir, 'slurm')
            slurm_script_list = os.listdir(git_slurm_dir)

            ## connect to slurm master
            slurm_master = '172.21.47.44'
            ED25519KEY='/home/ubuntu/.ssh/jeremiah-1492718018'
            transport = paramiko.Transport((slurm_master, 22))
            ed25519_key = paramiko.Ed25519Key.from_private_key_file(ED25519KEY)
            transport.connect(username='ubuntu', pkey=ed25519_key)

            ## transfer shell scripts to slurm master
            sftp = paramiko.SFTPClient.from_transport(transport)
            slurm_job_dir = '/home/ubuntu/airflow'
            put_slurm_scripts(sftp, slurm_job_dir, job_git_dir)

            ## sbatch slurm scripts
            client = paramiko.SSHClient()
            client.load_system_host_keys()
            client.connect(slurm_master, pkey=ed25519_key)
            for slurm_script in slurm_script_list:
                remote_shell_path = os.path.join(slurm_job_dir, job_creation_uuid, 'slurm', slurm_script)
                print('sbatch ' + remote_shell_path)
                stdin, stdout, stderr = client.exec_command('sbatch ' + remote_shell_path)
                slurm_id = stdout.read()
                print(str(slurm_id))
                time.sleep(61)
            client.close()

            ## remove slurm scripts from slurm master
            remote_dir = os.path.join('/home/ubuntu/airflow',os.path.basename(job_git_dir))
            rm_slurm_scripts(sftp, remote_dir)
            sftp.rmdir(remote_dir)
            transport.close()
    ## remove s3 json file
    return

def s3_get_key(ti):
    s3_bucket = ti.xcom_pull('check_s3', key='s3_bucket')
    s3_conn_id = ti.xcom_pull('check_s3', key='s3_conn_id')
    s3_host = ti.xcom_pull('check_s3', key='s3_host')
    s3_key = ti.xcom_pull('check_s3', key='s3_key')
    source_s3 = S3Hook(s3_conn_id=s3_conn_id, s3_host=s3_host)
    print('s3_bucket=%s' % s3_bucket)
    print('s3_conn_id=%s' % s3_conn_id)
    print('s3_host=%s' % s3_host)
    print('s3_key=%s' % s3_key)
    source_bucket = source_s3.get_bucket(s3_bucket)
    source_s3_key_object = source_bucket.get_key(s3_key)
    with NamedTemporaryFile(mode='w+b') as f_source:
        source_s3_key_object.get_contents_to_file(f_source)
        f_source.flush()
        source_s3.connection.close()
        create_run_jobs(queue_json_file=f_source)
    return

def job_creator(**kwargs):
    print('kwargs=%s' % kwargs)
    ti = kwargs['ti']
    jobs_file = s3_get_key(ti)
    # pull s3 file
    # clone git repo
    # run job creator using s3 file in repo
    # add new jobs to repo
    # commit / push new jobs
    # use ssh to queue jobs in slurm
    # delete s3 file
    return

pull = PythonOperator(
    task_id='et',
    dag=dag,
    provide_context=True,
    python_callable=job_creator)

pull.set_upstream(sensor)
from datetime import datetime
print(datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%S.%f'))



def manual():
    import os
    import paramiko
    import time
    
    job_creation_uuid = job_git_dir = 'c757a93a-dda1-4590-9724-9ecb9c7ca754'
    git_slurm_dir = os.path.join(job_git_dir, 'slurm')
    slurm_script_list = os.listdir(git_slurm_dir)
    slurm_master = '172.21.47.44'
    ED25519KEY='/home/ubuntu/.ssh/jeremiah-1492718018'
    transport = paramiko.Transport((slurm_master, 22))
    ed25519_key = paramiko.Ed25519Key.from_private_key_file(ED25519KEY)
    transport.connect(username='ubuntu', pkey=ed25519_key)

    #paste put_slurm_scripts

    sftp = paramiko.SFTPClient.from_transport(transport)
    slurm_job_dir = '/home/ubuntu/airflow'
    put_slurm_scripts(sftp, slurm_job_dir, job_git_dir)
    
    client = paramiko.SSHClient()
    client.load_system_host_keys()
    client.connect(slurm_master, pkey=ed25519_key)
    for slurm_script in slurm_script_list:
        remote_shell_path = os.path.join(slurm_job_dir, job_creation_uuid, 'slurm', slurm_script)
        print('sbatch ' + remote_shell_path)
        stdin, stdout, stderr = client.exec_command('sbatch ' + remote_shell_path)
        slurm_id = stdout.read()
        print(str(slurm_id))
        time.sleep(61)
    client.close()
