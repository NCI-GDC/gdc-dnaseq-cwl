gdc-readonlyrepl

._pg_edges

_links
_backRef

props
sysan

.edges_out
.edges_in
.get_edges()

al = g.nodes(Case).props(submitter_id='TCGA-DEV-2-CASE-0001')

.all()
.one()
.scalar() 


g.nodes(Aliquot).ids(aliquot_id).count()
1L

g.nodes(Case).path('samples.portions.analytes.aliquots').ids(aliquot_id).all()


g.nodes(Case).path('samples.portions.analytes.aliquots').ids(aliquot_id).all()

g.nodes(Case).path('samples.aliquots').ids(aliquot_id).all()

g.nodes(Case).subq_path('samples.portions.analytes.aliquots', lambda q: q.ids(aliquot_id))


# legacy
File

In [137]: bam._related_cases


case = g.nodes(Case).subq_path('samples.portions.analytes.aliquots.files', lambda q: q.ids('c2007bc3-ed7f-4648-
8643-e7521c73acde')).one()

 files = g.nodes(File).subq_path('aliquots.analytes.portions.samples.cases', lambda q: q.ids('b4225c44-b9b6-46c5-aabf-7b0d9a9fe20b').all()

In [152]: files[0].experimental_strategies[0].props

In [153]: files = g.nodes(File).subq_path('aliquots.analytes.portions.samples.cases', lambda q: q.ids('b4225c44-b9b6-46c5-aabf-7b0d9a9fe20b')).subq_path('experimental_strategies', lambda q: q.props(name='WXS')).all()                          

In [158]: files = g.nodes(File).subq_path('aliquots.analytes.portions.samples.cases', lambda q: q.ids('b4225c44-b9b6-46c5-aabf-7b0d9a9fe20b')).subq_path('experimental_strategies', lambda q: q.props(name='WXS')).all()

In [168]: g.nodes(sa.distinct(File.state)).all()
Out[168]: 
[(u'error'),
 (u'live'),
 (u'md5summing'),
 (u'submitted'),
 (u'uploaded'),
 (u'validated'),
 (None)]



# 2016-06-30
platforms = g.nodes(Platform.name).distinct(Platform._props['name']).all()
exps = g.nodes(ExperimentalStrategy.name).distinct(ExperimentalStrategy._props['name']).all()
node2 = g.nodes().get("618b2a2f-ee34-4e9f-ad50-b561264b0aae")


psql -U jeremiahsavage -d test -h 172.17.1.80  -c "COPY ( select uuid from fastqc_summary group by uuid having count(uuid) > 2 order by uuid ) TO STDOUT WITH CSV HEADER " > output2.csv

psql -U jeremiahsavage -d test -h 172.17.1.80  -c "COPY ( select uuid from fastqc_summary group by uuid having count(uuid) > 2 order by uuid ) TO STDOUT" > output.csv


count = 0
node_size = dict()
with open('output.csv', 'r') as f_open:
    for line in f_open:
        node = g.nodes().get(line.strip())
        node_size[line.strip()] = node.file_size

import operator
sorted_size = sorted(node_size.items(), key=operator.itemgetter(1))


$ curl 172.17.46.15/v0/did/113819e6-e59f-423c-ba00-2128b0e8f3e5
{
  "acl": [],
  "did": "113819e6-e59f-423c-ba00-2128b0e8f3e5",
  "rev": "a9ff2689-634e-4193-bc94-5997c3a41edc",
  "urls": [
    "s3://cleversafe.service.consul/tcga_cghub_protected_3/0f73fa63-5eed-422f-8cb2-b9f748d2aa9f/C1872.TCGA-IB-7889-01A-11D-2153-01.1.bam"
  ]
