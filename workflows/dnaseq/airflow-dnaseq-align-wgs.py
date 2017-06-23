from datetime import datetime, timedelta
import os
from tempfile import NamedTemporaryFile, TemporaryDirectory
import shutil

from airflow import DAG
from airflow.hooks.S3_hook import S3Hook
from airflow.operators.python_operator import PythonOperator
from airflow.operators.sensors import S3KeySensor

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

dag = DAG('dnaseq-align-wgs',
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


def create_run_jobs(queue_json_file):
    with TemporaryDirectory() as temp_dir:
        # create jobs
        job_dir = create_jobs.run(queue_json_file, temp_dir)
        job_uuid = os.path.basename(job_dir)
        job_git_dir = os.path.join(temp_dir, job_uuid)

        # clone git repo
        repo_dir=os.path.join(temp_dir, os.path.basename(WORKFLOW_JOBS_GIT).split('.')[0])
        git_repo = Repo.clone_from(WORKFLOW_JOBS_GIT, repo_dir)

        # add new jobs to repo
        os.rename(job_dir, job_git_dir)
        git_repo.index.add([job_git_dir])
        git_repo.index.commit("airflow add jobs")
        origin = git_repo.remote(name='origin')
        origin.push()

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
