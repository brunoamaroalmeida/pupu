#!/bin/bash
CREDIBLE_MEDIA="
www.bbc.com
www.cnn.com
www.telegraph.co.uk
www.politico.com
www.theguardian.com
www.usatoday.com
www.nytimes.com
www.wsj.com
www.dailymail.co.uk
www.foxnews.com
www.nbcnews.com
"

FAKE_MEDIA="
www.burrardstreetjournal.com
www.duffelblog.com
www.thepoke.co.uk
thevalleyreport.com
empireherald.com
cityworldnews.com
bizstandardnews.com
www.globalresearch.ca
nationalreport.net
now8news.com
empirenews.net
"

for site in $CREDIBLE_MEDIA; do
  docker run -i  --mount type=bind,source=/Users/bama/git/adhoc/fakeintelligence/results/,target=/results/ --env RESULTS_DIR="/results/credible/" --env TARGET_SITE=$site -t sitesnap;
done
for site in $FAKE_MEDIA; do
  docker run -i  --mount type=bind,source=/Users/bama/git/adhoc/fakeintelligence/results/,target=/results/ --env RESULTS_DIR="/results/fake/" --env TARGET_SITE=$site -t sitesnap;
done
