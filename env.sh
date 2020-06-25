# install via conda

conda install -y minimap2 samtools bcftools pysam bamtools pigz -c bioconda 

# install WHATSUP via pip

pip install git+https://bitbucket.org/whatshap/whatshap@split

# jsonの作成

echo "{ "filters" : [ { "id" : "inHP1", "tag" : "HP:1" }, { "id" : "inHP2", "tag" : "HP:2" } ], "rule" : "!(inHP1 | inHP2)" }" > filter_script.json


#===================#

# referenceの準備

##  ref/hs37d5.fa.gz の作成

#===================#


# CCSリードのマッピング

## CCS: dirname of fa.gz

CCS=$1

## CCSn: filename of fa.gz

CCSn=$(basename $CCS)

## ref: dirname of hs37d5.fa.gz like /../../ref/hs37d5.fa.gz
## ref: dirname of hg38 like /../../ref/hg38

ref=$2

## number of CPU cores

core=$3

# CCS_cram: cram of CCS  maooed to ref

CCS_cram=cram/$CCSn.cram

# CCS_cram_sorted: cram of CCS  maooed to ref

CCS_cram_sort=cram/${CCSn}.sorted.cram

mkdir -p cram
minimap2 -t 32 -R '@RG\tID:1\tSM:HG002' -ax asm20 $ref \
$CCS | \
samtools view -T $ref -C - > $CCS_cram


samtools sort -@ 32 -O cram -o $CCS_cram_sort $CCS_cram
samtools index $CCS_cram_sort


#==別ファイル==#


# CLRリードのマッピング

## CLR: dirname of fq.gz

CLR=$1

CLRn=$(basename $CLR)

CLR_cram=cram/$CLRn.cram

CLR_cram_sort=cram/${CLRn}.sorted.cram

minimap2 -t 32 -R '@RG\tID:1\tSM:HG002' -ax map-pb $ref \
$CLR | \
samtools view -T $ref -C - > $CLR_cram

samtools sort -@ 32 -O cram -o $CLR_cram $CLR_cram_sort
samtools index $CLR_cram_sort


#====#

# gene annotationのじゅんび

mkdir -p vcf/deepvariant/
mv pacbio-15kb-hapsort-wgs.vcf.gz vcf/deepvariant/

# deep variant hg38-no_alt_vs_B756.sequel2_CCS.minimap2.deep_variant.gvcf.gz

mkdir -p vcf/deepvariant/
VCF=$1
VCFnew=vcf/deepvariant/$(basename $1)

ln -s $VCF $VCFnew





















