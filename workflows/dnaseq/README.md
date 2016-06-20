To run DNASeq harmonization workflow
------------------------------------
1. On VM, ensure `virtualenvwrapper` is installed:
        $ sudo su -
        # apt-get update && apt-get install virtualenvwrapper -y
        # exit

2. configure `virtualenvwrapper`
        $ grep virtualenvwrapper.sh ~/.bashrc
if there is no result:
        $ echo "source /usr/share/virtualenvwrapper/virtualenvwrapper.sh" >> ~/.bashrc
        $ exit

3. create a virtualenv for cwltool
        $ mkvirtualenv --python /usr/bin/python2 cwl
upgrade pip

4. When virtualenv is first created (3), the vitualenv will be activated. To activate virtualenv on late login sessions:
        $ workon cwl
To deactive a virtualenv:
        $ deactivate

5. enable proxy to access pypi.org
        $ export http_proxy=http://cloud-proxy:3128; export https_proxy=http://cloud-proxy:3128;

6. upgrade pip
        $ pip install --upgrade pip

7. get the CDIS patched version of cwltool
        $ wget https://github.com/jeremiahsavage/cwltool/archive/0.1.tar.gz

8. install cwltool and its dependencies
        $ pip install 0.1.tar.gz --no-cache-dir

9. get the DNASeq CWL Workflow
        $ git clone https://github.com/NCI-GDC/cocleaning-cwl.git