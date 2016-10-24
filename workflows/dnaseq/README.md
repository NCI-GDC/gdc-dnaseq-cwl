To run DNASeq harmonization workflow
------------------------------------
After completing numbered installation steps below, these 3 steps will suffice to run workflows:

        $ workon cwl
        $ cd /mnt/SCRATCH/dnaseq_example
        $ nohup cwltool --tmpdir-prefix /mnt/SCRATCH/tmp/ --tmp-outdir-prefix /mnt/SCRATCH/tmp/  --debug ~/cocleaning-cwl/workflows/dnaseq/transform.cwl  ~/cocleaning-cwl/workflows/dnaseq/ex_transform.json &

---

0. install needed packages

        if you have a proxy, enable for apt:
        $ echo 'Acquire::http::Proxy "http://cloud-proxy:3128";' >> /etc/apt/apt.conf.d/01Proxy
        $ echo 'Acquire::https::Proxy "http://cloud-proxy:3128";' >> /etc/apt/apt.conf.d/01Proxy

        $ sudo aptitude update
        $ sudo aptitude install apt-transport-https ca-certificates htop libffi-dev libssl-dev nodejs python-dev virtualenvwrapper

1. prep storage

        $ sudo mkfs.ext4 /dev/vdb
        $ sudo rm -rf /mnt
        $ sudo mount /dev/vdb /mnt
        $ sudo mkdir /mnt/SCRATCH
        $ sudo chown 777 /mnt/SCRATCH

2. prep docker

        create a dir for image storage (will store ~12GiB of images):
        $ mkdir /mnt/SCRATCH/docker

        enable docker storage in dir:
        $ sudo echo "DOCKER_OPTS=\"--dns 8.8.8.8 --dns 8.8.4.4 -g /mnt/SCRATCH/docker/\"" >> /etc/default/docker

        enable non-root user to run docker:
        $ sudo gpasswd -a ubuntu docker
        if you have a proxy, enable for docker:
        $ sudo echo "export http_proxy=http://cloud-proxy:3128; export https_proxy=http://cloud-proxy:3128" >> /etc/default/docker
        $ sudo service docker restart
        $ exit (non-root only gain group access to docker when exit/login - make sure you are ENTIRELY logged out of VM before proceeding)

3. log back in. configure `virtualenvwrapper`

        $ echo "source /usr/share/virtualenvwrapper/virtualenvwrapper.sh" >> ~/.bashrc
        $ exit

4. log back in. If needed, enable proxy to access pypi.org

        $ export http_proxy=http://cloud-proxy:3128; export https_proxy=http://cloud-proxy:3128;

5. create a virtualenv for cwltool

        $ mkvirtualenv --python /usr/bin/python2 cwl

6. When virtualenv is first created (3), the vitualenv will be activated. To activate virtualenv on later login sessions:

        $ workon cwl

   To deactive a virtualenv (don't do this now, just FYI)

        $ deactivate

7. upgrade pip

        $ pip install --upgrade pip

8. enable SSL connections

        $ pip install 'requests[security]'  --no-cache-dir

9. get the CDIS patched version of cwltool

        $ wget https://github.com/jeremiahsavage/cwltool/archive/1.0_gdc_e.tar.gz

10. install cwltool and its dependencies

        $ pip install 1.0_gdc_e.tar.gz --no-cache-dir

11. get the DNASeq CWL Workflow

        $ git clone https://github.com/NCI-GDC/cocleaning-cwl.git

12. The essential workflow to perform DNASeq BAM harmonization is

        cocleaning-cwl/workflows/dnaseq/transform.cwl

    and an example input file is

        cocleaning-cwl/workflows/dnaseq/ex_transform.json

13. get reference files

        $ mkdir /mnt/SCRATCH/hg38\_reference
        $ cd /mnt/SCRATCH/hg38\_reference

    dbsnp vcf (two choices):

    (1) original data generation:

        $ wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/hg38/hg38bundle/dbsnp_144.hg38.vcf.gz
        $ gunzip dbsnp_144.hg38.vcf.gz
        $ sed -i 's/\(^[1-9,X,Y,M]\)/chr\1/g' dbsnp_144.hg38.vcf
        $ gzip dbsnp_144.hg38.vcf

     or (2) pull modified data from gdc:

        $ wget https://gdc-api.nci.nih.gov/data/4ba1c087-ec80-47c4-a9d5-e9bb9933fef4 -O dbsnp_144.hg38.vcf.gz

    reference genome:

        $ wget https://gdc-api.nci.nih.gov/data/62f23fad-0f24-43fb-8844-990d531947cf
        tar xvf 62f23fad-0f24-43fb-8844-990d531947cf

    bwa indexed genome:

        $ wget https://gdc-api.nci.nih.gov/data/964cbdac-1043-4fae-b068-c3a65d992f6b
        tar xvf 964cbdac-1043-4fae-b068-c3a65d992f6b

13. Get example data

        Single readgroup BAM which maps with `bwa mem`:
        $ mkdir /mnt/SCRATCH/NA12878_chr20_lowcvg/
        $ cd /mnt/SCRATCH/
        $ wget ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/phase3/data/NA12878/alignment/NA12878.chrom20.ILLUMINA.bwa.CEU.low_coverage.20121211.bam
        
13. Run workflow

        $ mkdir /mnt/SCRATCH/NA12878_chr20_lowcvg/harmonize/
        $ cd /mnt/SCRATCH/NA12878_chr20_lowcvg/harmonize/
        $ nohup cwltool --debug --tmpdir-prefix . --cachedir . ~/cocleaning-cwl/workflows/dnaseq/transform.cwl ~/cocleaning-cwl/workflows/dnaseq/NA12878_chr20_lowcvg_transform.json &
