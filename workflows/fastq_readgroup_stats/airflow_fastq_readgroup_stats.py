from datetime import datetime, timedelta
import json
import os
from tempfile import NamedTemporaryFile, TemporaryDirectory
import shutil
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

def put_slurm_scripts(sftp, slurm_dir):
    os.chdir(os.path.split(slurm_dir)[0])
    parent=os.path.split(localpath)[1]
    remotepath = '/home/ubuntu/airflow'
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

            ## sbatch slurm scripts
            #for slurm_script in slurm_script_list:
            slurm_master = '172.21.47.44'
            ED25519KEY='/home/ubuntu/.ssh/jeremiah-1492718018'
            transport = paramiko.Transport((slurm_master, 22))
            ed25519_key = paramiko.Ed25519Key.from_private_key_file(ED25519KEY)
            transport.connect(username='ubuntu', pkey=ed25519_key)
            sftp = paramiko.SFTPClient.from_transport(transport)
            put_slurm_scripts(sftp, git_slurm_dir)
            
            ssh = paramiko.SSHClient()
            ssh.load_system_host_keys()
            ssh.connect('example.com')

            remote_dir = os.path.join('/home/ubuntu/airflow',os.path.basename(git_slurm_dir))
            rm_slurm_scripts(sftp, remote_dir)
            sftp.rmdir(remote_dir)
            transport.close()

    ## remove s3 json file
    #return


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


# et = S3FileTransformOperator(
#     xcom_task_id='check_s3',
#     task_id='test_et',
#     dag=dag
#     )

# t1 = BashOperator(
#     task_id='test1',
#     bash_command='touch ${HOME}/test1',
#     dag=dag)


# t2 = BashOperator(
#     task_id='test2',
#     bash_command='touch ${HOME}/test2',
#     dag=dag)


pull.set_upstream(sensor)
#et.set_upstream(sensor)

# t1.set_upstream(sensor)
# t2.set_upstream(t1)

# t1 = BashOperator(
#     task_id='create_cwl_slurm_jobs',
#     bash_command='python dnaseq/create_jobs.py --queue_json queue.json',
#     dag=dag)

# t2 = BashOperator(
#     task_id='push_jobs_to_git_repo',
#     bash_command='cd workflow-jobs && git add * && git commit -am "add jobs" && git push && cd -',
#     dag=dag)

# t3 = BashOperator(
#     task_id='get_slurm_list',
#     bash_command
#     )

# t2 = BashOperator(
#     task_id='task2',
#     depends_on_past=False,
#     bash_command='echo a big hadoop job putting files on s3',
#     trigger_rule='all_failed',
#     dag=dag)

# t3 = BashOperator(
#     task_id='task3',
#     depends_on_past=False,
#     bash_command='echo im next job using s3 files',
#     trigger_rule='all_done',
#     dag=dag)

# t3.set_upstream(sensor)
# t3.set_upstream(t2)


from datetime import datetime
print(datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%S.%f'))
