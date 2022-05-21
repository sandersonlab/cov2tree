
mkdir working
cd working
# Replace MYSECRETKEY with the contents of the key
sed  "s/MYSECRETKEY/$MYKEY/g" ../s3cfg > s3cfg
s3cmd put -P ../README.md -c s3cfg s3://cov2tree/README.md
wget -q https://hgwdev.gi.ucsc.edu/~angie/UShER_SARS-CoV-2/public-latest.metadata.tsv.gz
wget -q https://raw.githubusercontent.com/theosanderson/taxonium/master/taxoniumtools/test_data/hu1.gb
wget -q https://hgwdev.gi.ucsc.edu/~angie/UShER_SARS-CoV-2/public-latest.all.masked.pb.gz
wget -q https://raw.githubusercontent.com/theosanderson/treeShears/master/treeshears.py

sudo pip3 install taxoniumtools chronumental

usher_to_taxonium --input public-latest.all.masked.pb.gz --output ./public.jsonl.gz \
--metadata public-latest.metadata.tsv.gz --genbank hu1.gb --columns genbank_accession,country,date,pangolin_lineage \
--overlay_html ../ack.html --title Cov2Tree --remove_after_pipe --chronumental_date_output=chron_dates.tsv --chronumental_tree_output=chron_tree.nwk \
--clade_types=nextstrain,pango --shear

s3cmd put -P public.jsonl.gz -c s3cfg s3://cov2tree/latest_public_custom.jsonl.gz 
