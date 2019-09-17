#!/bin/bash

ALL_TEXT=$(find results -name out.txt)

for i in $ALL_TEXT; do
  TEXT=$(cat $i | head -n 70)
  echo "x: $i";
  OUTFILE=$(echo $i | sed  "s/\//_/g")
  aws comprehend detect-sentiment --language-code en --text "$TEXT" --output json | jq . > aws_results/${OUTFILE}-dsentiment.json
  aws comprehend detect-entities --language-code en --text "$TEXT" --output json | jq  . > aws_results/${OUTFILE}-dentities.json


done;

ALL_IMAGE=$(find results -name out.png)

for i in $ALL_IMAGE; do
  IMAGE=$i
  echo "x: $i";
  OUTFILE=$(echo $i | sed  "s/\//_/g")
  aws rekognition detect-labels --image-bytes fileb://$IMAGE --output json | jq . > aws_results/${OUTFILE}-dlabels.json
  aws rekognition detect-text --image-bytes fileb://$IMAGE --output json | jq .TextDetections[].DetectedText > aws_results/${OUTFILE}-dtext.json
  aws rekognition recognize-celebrities --image-bytes fileb://$IMAGE --output json | jq . > aws_results/${OUTFILE}-rcelebrities.json
  aws rekognition detect-moderation-labels --image-bytes fileb://$IMAGE --output json | jq . > aws_results/${OUTFILE}-dmoderationlabels.json

done;


ALL_TEXT=$(ls aws_results/*dtext.json)
for i in $ALL_TEXT; do
  TEXT=$(cat $i)
  echo "x: $i";
  OUTFILE=$(echo $i | sed  "s/\//_/g")
  aws comprehend detect-sentiment --language-code en --text "$TEXT" --output json | jq . > aws_results/${OUTFILE}-esentiment.json


done;
