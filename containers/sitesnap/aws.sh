#!/bin/bash

TEXT=$(cat ../../results/credible/www.telegraph.co.uk/04-09-2019/out.txt | head -n 70)
aws comprehend detect-sentiment --language-code en --text "$TEXT" --output json | jq .

IMAGE="../../results/credible/www.telegraph.co.uk/04-09-2019/out.png"
aws rekognition detect-labels --image-bytes fileb://$IMAGE --output json | jq .
