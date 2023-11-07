# NPPES Data Definition
export NPPES_FILENAME='NPPES_Data_Dissemination_October_2023'
export NPIDATA_FILENAME='npidata_pfile_20050523-20231008'
export tmp_dir=$(mktemp -d)

# Fetch & Preprocess
curl -OJ --output-dir ${tmp_dir} https://download.cms.gov/nppes/${NPPES_FILENAME}.zip
cd ${tmp_dir} && unzip ${NPPES_FILENAME}.zip  && cd - &&
csv2parquet "${tmp_dir}/${NPIDATA_FILENAME}.csv" "./data/inputs/${NPIDATA_FILENAME}.zstd.parquet" -s ~/tools/bedrock-data/nppes.schema --max-read-records 1 --max-row-group-size 2048 --compression=zstd 
&& rm -rf ${tmp_dir}