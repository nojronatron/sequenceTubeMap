#!/usr/bin/env bash
set -e

function usage() {
    echo >&2 "${0}: Extract graph and read chunks for a region, producing a referencing line for a BED file on standard output"
    echo >&2
    echo >&2 "Usage: ${0} -x mygraph.xg [-h mygraph.gbwt] -r chr1:1-100 [-d 'Description of region'] [-n 123 [-n 456]] -o chunk-chr1-1-100 [-g mygam1.gam [-g mygam2.gam ...]] >> regions.bed"
    exit 1
}

NODE_COLORS=()

while getopts x:h:g:r:o:d:n: flag
do
    case "${flag}" in
        x) GRAPH_FILE=${OPTARG};;
        h) HAPLOTYPE_FILE=${OPTARG};;
        g) GAM_FILES+=("$OPTARG");;
        r) REGION=${OPTARG};;
        o) OUTDIR=${OPTARG};;
        d) DESC="${OPTARG}";;
        n) NODE_COLORS+=("${OPTARG}");;
        *)
            usage
            ;;

    esac
done

if ! command -v jq &> /dev/null
then
    echo >&2 "This script requires jq, exiting..."
    exit 1
fi

if [[ -z "${REGION}" ]] ; then
    echo >&2 "You must specify a region with -r"
    echo >&2
    usage
fi

if [[ -z "${GRAPH_FILE}" ]] ; then
    echo >&2 "You must specify a graph with -x"
    echo >&2
    usage
fi

if [[ -z "${OUTDIR}" ]] ; then
    echo >&2 "You must specify an output directory with -o"
    echo >&2
    usage
fi

if [[ -z "${DESC}" ]] ; then
    DESC="Region ${REGION}"
fi

echo >&2 "Graph File: " $GRAPH_FILE
echo >&2 "Haplotype File: " $HAPLOTYPE_FILE
echo >&2 "Region: " $REGION
echo >&2 "Output Directory: " $OUTDIR
echo >&2 "Node colors: " ${NODE_COLORS[@]}

rm -fr $OUTDIR
mkdir -p $OUTDIR

vg_chunk_params=(-x $GRAPH_FILE -g -c 20 -p $REGION -T -b $OUTDIR/chunk -E $OUTDIR/regions.tsv)

# construct track JSON for graph file
jq -n --arg trackFile "${GRAPH_FILE}" --arg trackType "graph" --argjson trackColorSettings '{"mainPalette": "plainColors", "auxPalette": "greys"}' '$ARGS.named' >> $OUTDIR/tracks.json

# construct track JSON for haplotype file, if provided
if [[ ! -z "${HAPLOTYPE_FILE}" ]] ; then
    jq -n --arg trackFile "${HAPLOTYPE_FILE}" --arg trackType "haplotype" --argjson trackColorSettings '{"mainPalette": "blues", "auxPalette": "reds"}' '$ARGS.named' >> $OUTDIR/tracks.json
fi

# construct track JSON for each gam file
echo >&2 "Gam Files:"
for GAM_FILE in "${GAM_FILES[@]}"; do
    echo >&2 " - $GAM_FILE"
    jq -n --arg trackFile "${GAM_FILE}" --arg trackType "read" --argjson trackColorSettings '{"mainPalette": "blues", "auxPalette": "reds"}' '$ARGS.named' >> $OUTDIR/tracks.json
    vg_chunk_params+=(-a $GAM_FILE)
done

# construct node file
if [[ ! -z "${NODE_COLORS}" ]] ; then
    for NODENAME in "${NODE_COLORS[@]}"; do
        echo >&2 "Highlighted node: $NODENAME"
        printf "$NODENAME\n" >> $OUTDIR/nodeColors.tsv
    done
fi

# Call vg chunk
vg chunk "${vg_chunk_params[@]}" > $OUTDIR/chunk.vg

for file in `ls $OUTDIR/`
do
    printf "$file\n" >> $OUTDIR/chunk_contents.txt
done

# Print BED line
cat $OUTDIR/regions.tsv | cut -f1-3 | tr -d "\n"
printf "\t${DESC}\t${OUTDIR}\n"
