To run DNASeq harmonization workflow
------------------------------------
After completing numbered installation steps below, these 3 steps will suffice to run workflows:

        $ workon cwl
        $ cd /mnt/SCRATCH/dnaseq_example
        $ nohup cwltool --debug --tmpdir-prefix tmp/ --cachedir cache/ ~/cocleaning-cwl/workflows/dnaseq/transform.cwl ~/cocleaning-cwl/workflows/dnaseq/NA12878.chrom20.ILLUMINA.bwa.CEU.low_coverage.20121211.json &

---

0. install needed packages

        if you have a proxy, enable for apt:
        $ sudo sh -c "echo 'Acquire::http::Proxy "http://cloud-proxy:3128";' >> /etc/apt/apt.conf.d/01Proxy"
        $ sudo sh -c "echo 'Acquire::https::Proxy "http://cloud-proxy:3128";' >> /etc/apt/apt.conf.d/01Proxy"

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

        enable docker storage in scratch dir:
        $ sudo echo "DOCKER_OPTS=\"-g /mnt/SCRATCH/docker/\"" >> /etc/default/docker

        enable non-root user to run docker:
        $ sudo gpasswd -a ubuntu docker

        if you have a proxy, enable for docker:
        $ sudo echo "export http_proxy=http://cloud-proxy:3128; export https_proxy=http://cloud-proxy:3128" >> /etc/default/docker
        
        restart docker service
        $ sudo service docker restart
        $ exit (non-root only gain group access to docker when exit/login - make sure you are ENTIRELY logged out of VM before proceeding)


3. log back in. configure `virtualenvwrapper`

        $ echo "source /usr/share/virtualenvwrapper/virtualenvwrapper.sh" >> ~/.bashrc
        $ exit

4. log back in. If needed, enable proxy to access pypi.org and github.com

        $ export http_proxy=http://cloud-proxy:3128; export https_proxy=http://cloud-proxy:3128;

5. create a virtualenv for cwltool

        $ mkvirtualenv --python /usr/bin/python2 cwl

6. When virtualenv is first created, the vitualenv will be activated. To activate virtualenv on later login sessions:

        $ workon cwl

   To deactive a virtualenv (don't do this now, just FYI)

        $ deactivate

7. upgrade pip

        $ pip install --upgrade pip

8. enable SSL connections

        $ pip install 'requests[security]'  --no-cache-dir

9. get the CDIS tested version of cwltool

        $ wget https://github.com/NCI-GDC/cwltool/archive/1.0_gdc_f.tar.gz

10. install cwltool and its dependencies

        $ pip install 1.0_gdc_f.tar.gz --no-cache-dir

11. get the DNASeq CWL Workflow

        $ git clone https://github.com/NCI-GDC/cocleaning-cwl.git

12. The workflow to perform DNASeq BAM harmonization is

        cocleaning-cwl/workflows/dnaseq/transform.cwl

    and an example input file is

        cocleaning-cwl/workflows/dnaseq/NA12878.chrom20.ILLUMINA.bwa.CEU.low_coverage.20121211.json

13. get reference files

        $ mkdir /mnt/SCRATCH/hg38_reference
        $ cd /mnt/SCRATCH/hg38_reference

    dbsnp vcf (two choices):

    (1) modified data generation:

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

14. Get example data: 1 readgroup BAM which uses `bwa mem`

        Single readgroup BAM which maps with `bwa mem`, and contains Paired-End reads (SRR622461_1.fq.gz, SRR622461_2.fq.gz), Single-End (SRR622461_s.fq.gz) reads, and Orphaned (SRR622461_o1.fq.gz) reads, all of which are mapped to the harmonized BAM
        $ cd /mnt/SCRATCH/
        $ wget ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/phase3/data/NA12878/alignment/NA12878.chrom20.ILLUMINA.bwa.CEU.low_coverage.20121211.bam

15. Run workflow

        $ mkdir /mnt/SCRATCH/NA12878.chrom20.ILLUMINA.bwa.CEU.low_coverage.20121211
        $ cd /mnt/SCRATCH/NA12878.chrom20.ILLUMINA.bwa.CEU.low_coverage.20121211/
        $ mkdir tmp cache
        $ nohup cwltool --debug --tmpdir-prefix tmp/ --cachedir cache/ ~/cocleaning-cwl/workflows/dnaseq/transform.cwl ~/cocleaning-cwl/workflows/dnaseq/NA12878.chrom20.ILLUMINA.bwa.CEU.low_coverage.20121211.json &

16. Other example data

        16 readgroup BAM which uses `bwa aln` (all readgroup reads < 70bp; PE, SE and o1 reads)
        ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/data/NA12889/alignment/NA12889.chrom20.ILLUMINA.bwa.CEU.low_coverage.20101123.bam
        use cocleaning-cwl/workflows/dnaseq/NA12889.chrom20.ILLUMINA.bwa.CEU.low_coverage.20101123.json

        22 readgroup BAM which uses `bwa mem` (all readgroup reads > 70bp; PE, SE and o1 reads)
        ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/data/NA11829/alignment/NA11829.chrom20.ILLUMINA.bwa.CEU.low_coverage.20130415.bam
        use cocleaning-cwl/workflows/dnaseq/NA11829.chrom20.ILLUMINA.bwa.CEU.low_coverage.20130415.json

        16 readgroup BAM which uses both `bwa aln` and `bwa mem` (some readgroup reads < 70bp, some > 70bp; PE, SE and o1 reads)
        ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase1/data/NA11829/alignment/NA11829.chrom20.ILLUMINA.bwa.CEU.low_coverage.20101123.bam
        use cocleaning-cwl/workflows/dnaseq/NA11829.chrom20.ILLUMINA.bwa.CEU.low_coverage.20101123.json
