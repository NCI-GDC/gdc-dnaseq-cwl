OUT OF DATE AND OBSOLETE INSTRUCTIONS. NEED TO UPDATE.

To run DNASeq harmonization workflow
------------------------------------
TL;DR

        $ workon cwl
        $ cd /mnt/SCRATCH/genoMel_harmon
        $ nohup cwltool --tmpdir-prefix /mnt/SCRATCH/tmp/ --tmp-outdir-prefix /mnt/SCRATCH/tmp/  --debug ~/cocleaning-cwl/workflows/dnaseq/dnaseq_workflow.cwl.yaml  ~/cocleaning-cwl/workflows/dnaseq/genoMel.json &

---
0. prep scratch dir, store docker in scratch, add user to docker group, install debs

        $ sudo su
        ## ensure following lines in /etc/apt/apt.conf.d/01Proxy:
                  Acquire::http::Proxy "http://cloud-proxy:3128";
                  Acquire::https::Proxy "http://cloud-proxy:3128";
        # mkdir /mnt/SCRATCH
        # chown 777 /mnt/SCRATCH
        # aptitude update
        # aptitude install apt-transport-https ca-certificates python-dev libffi-dev libssl-dev htop s3cmd virtualenvwrapper nodejs
        # mkdir /mnt/SCRATCH/docker
        # chown ubuntu /home/ubuntu/.dockercfg
        # gpasswd -a ubuntu docker
        # echo "DOCKER_OPTS=\"--dns 8.8.8.8 --dns 8.8.4.4 -g /mnt/SCRATCH/docker/\"" >> /etc/default/docker
        # echo "export http_proxy=http://cloud-proxy:3128; export https_proxy=http://cloud-proxy:3128" >> /etc/default/docker
        # service docker restart
        # exit
        $ exit (only gain group access to docker when exit/login)

2. configure `virtualenvwrapper`

  ```
        $ echo "source /usr/share/virtualenvwrapper/virtualenvwrapper.sh" >> ~/.bashrc
        $ exit
  ```

3. enable proxy to access pypi.org

        $ export http_proxy=http://cloud-proxy:3128; export https_proxy=http://cloud-proxy:3128;

4. create a virtualenv for cwltool

        $ mkvirtualenv --python /usr/bin/python2 cwl

5. When virtualenv is first created (3), the vitualenv will be activated. To activate virtualenv on later login sessions:

        $ workon cwl

  * To deactive a virtualenv:
  
  ```
        $ deactivate
  ```

6. upgrade pip

        $ pip install --upgrade pip

7. get the CDIS patched version of cwltool

        $ wget https://github.com/jeremiahsavage/cwltool/archive/1.0_gdc_e.tar.gz

8. install cwltool and its dependencies

        $ pip install 1.0_gdc_e.tar.gz --no-cache-dir

9. get the DNASeq CWL Workflow

        $ cd ${HOME}
        $ git clone https://github.com/NCI-GDC/cocleaning-cwl.git

10. The essential workflow to perform DNASeq BAM harmonization is

        cocleaning-cwl/workflows/dnaseq/transform.cwl
        
    , and an example input file is
    
        cocleaning-cwl/workflows/dnaseq/ex_transform.json

11. Run workflow

        $  cwltool --tmpdir-prefix /mnt/SCRATCH/tmp/ --tmp-outdir-prefix /mnt/SCRATCH/tmp/  --debug ~/cocleaning-cwl/workflows/dnaseq/dnaseq_workflow.cwl.yaml  ~/cocleaning-cwl/workflows/dnaseq/genoMel.json
