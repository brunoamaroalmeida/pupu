#!/bin/bash

echo "######## $TARGET_SITE ########"

# Enable GCP SDK
if [ "$GCP_ENABLED"  = true ]; then
  gcloud auth activate-service-account --key-file=$GCP_KEYFILE
fi

TODAY=$(date +'%m-%d-%Y')
RESULTS=${RESULTS_DIR}/${TARGET_SITE}/${TODAY}
RESULTS_RAW=${RESULTS}/raw
mkdir -p $RESULTS
mkdir -p $RESULTS_RAW

# Take a snapshot of the website
mkdir -p tmp && cd tmp
xvfb-run --server-args="-screen 0, 1280x1200x24" wkhtmltoimage --quality 100 --crop-h 800 $TARGET_SITE $RESULTS/out.png

if [ "$GCP_ENABLED"  = true ]; then
  echo "Use Vision API with the website snapshot"
  gcloud ml vision detect-labels $RESULTS/out.png > $RESULTS_RAW/labels.json
  gcloud ml vision detect-text $RESULTS/out.png > $RESULTS_RAW/text.json
  gcloud ml vision detect-web $RESULTS/out.png > $RESULTS_RAW/web.json

  gcloud ml vision detect-safe-search $RESULTS/out.png > $RESULTS_RAW/safe-search.json

fi

# Fetch all the images in the website
mkdir images && cd images
image-scraper $TARGET_SITE
if [ "$GCP_ENABLED"  = true ]; then
  echo "Use Vision API with the website fetched images"
  cd image*
  for i in `ls`; do
      echo $i;
      gcloud ml vision detect-labels $i >> $RESULTS_RAW/child-image-labels.json;
  done
fi

# Extract text out from website
lynx --dump $TARGET_SITE > $RESULTS/out.txt
# Filter out some irrelevant data
sed -i '/http:/d'  $RESULTS/out.txt
sed -i '/https:/d'  $RESULTS/out.txt
sed -i '/mailto:/d'  $RESULTS/out.txt
sed -i '/* [/d'  $RESULTS/out.txt

awk 'length($0)>40' $RESULTS/out.txt  > $RESULTS/out1.txt
iconv -f "windows-1252" -t "UTF-8" $RESULTS/out1.txt -o $RESULTS/out.txt
rm -fr $RESULTS/out1.txt

gcloud ml language analyze-sentiment --content-file=$RESULTS/out.txt > $RESULTS_RAW/text-sentiment.json

echo "Use Natural Language API with the website text"
gcloud ml language classify-text --content-file=$RESULTS/out.txt > $RESULTS_RAW/text-classify.json



# Generate report
cd $RESULTS/
/bin/bash /app/fireport.sh ${RESULTS_RAW} ${TARGET_SITE} > report.json;

echo "Done"
