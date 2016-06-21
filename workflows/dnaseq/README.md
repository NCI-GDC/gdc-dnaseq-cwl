To run DNASeq harmonization workflow
------------------------------------
TL;DR

        $ workon cwl
        $ cd /mnt/SCRATCH/genoMel_harmon
        $ nohup cwltool --tmpdir-prefix /mnt/SCRATCH/tmp/ --tmp-outdir-prefix /mnt/SCRATCH/tmp/  --debug ~/cocleaning-cwl/workflows/dnaseq/dnaseq_workflow.cwl.yaml  ~/cocleaning-cwl/workflows/dnaseq/genoMel.json &

---

1. On VM, ensure `virtualenvwrapper` is installed:

        $ sudo su -
        # apt-get update && apt-get install virtualenvwrapper -y
        # exit

2. configure `virtualenvwrapper`

        $ grep virtualenvwrapper.sh ~/.bashrc

  * if there is no result:

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

        $ wget https://github.com/jeremiahsavage/cwltool/archive/0.1.tar.gz

8. install cwltool and its dependencies

        $ pip install 0.1.tar.gz --no-cache-dir

9. get the DNASeq CWL Workflow

        $ cd ${HOME}
        $ git clone git@github.com:NCI-GDC/cocleaning-cwl.git
        $ cd cocleaning-cwl/
        $ git checkout feat/dnaseq_workflow

10. Make dir to store harmonized data

        $ mkdir -p /mnt/SCRATCH/genoMel_harmon
        $ cd /mnt/SCRATCH/genoMel_harmon

11. Run workflow

        $  cwltool --tmpdir-prefix /mnt/SCRATCH/tmp/ --tmp-outdir-prefix /mnt/SCRATCH/tmp/  --debug ~/cocleaning-cwl/workflows/dnaseq/dnaseq_workflow.cwl.yaml  ~/cocleaning-cwl/workflows/dnaseq/genoMel.json