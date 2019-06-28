#!/bin/bash
p=$1
NOW=$(date)

# Labels
LABELS=$(jq .responses[].labelAnnotations[].description $p/labels.json)
LABELS_S="{ \"labels\": ["
for i in $LABELS; do
 LABELS_S=${LABELS_S}${i}",";
done
LABELS_S="${LABELS_S::-1}"
LABELS_S=${LABELS_S}"]}"

# Child Labels
CHILD_LABELS=$(jq .responses[].labelAnnotations[].description $p/child-image-labels.json)
CHILD_LABELS_S="{ \"child_labels\": ["
for i in $CHILD_LABELS; do
 CHILD_LABELS_S=${CHILD_LABELS_S}${i}",";
done
CHILD_LABELS_S="${CHILD_LABELS_S::-1}"
CHILD_LABELS_S=${CHILD_LABELS_S}"]}"

# Text
TEXT=$(jq .responses[].fullTextAnnotation.text $p/text.json)
TEXT_S="{\"text\": $TEXT }"

# Web
WEB=$(jq .responses[].webDetection $p/web.json)

# Safe Search
SAFE_SEARCH=$(jq .responses[] $p/safe-search.json)

# Text classify
TEXT_CLASSIFY=$(jq . $p/text-classify.json)

# Text Sentiment
TEXT_SENTIMENT=$(jq .documentSentiment $p/text-sentiment.json)

REPORT="
{
\"timestamp\": \"$NOW\",
\"site\": \"$2\",
 \"report\": [
$CHILD_LABELS_S,
$LABELS_S,
$TEXT_S,
$WEB,
$SAFE_SEARCH,
{\"text-sentiment\": $TEXT_SENTIMENT },
{\"text-classify\": $TEXT_CLASSIFY }
]
}"

echo $REPORT
