FROM debian:latest
LABEL maintainer="Bruno Amaro Almeida | brunoamaro.com"

# Set the working directory to /app
WORKDIR /app
# Copy the current directory contents into the container at /app
ADD . /app

# Install dependencies
RUN apt-get update
RUN apt-get install lynx xvfb wkhtmltopdf procps zip python-pip curl jq lsb-release apt-utils -qy
RUN pip install ImageScraper

# Install GCP SDK
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get install google-cloud-sdk -y

# Set the environment values
ENV TARGET_SITE=https://www.cnn.com
ENV RESULTS_DIR=/results/
ENV GCP_ENABLED=true
ENV GCP_KEYFILE=pupu-gcp-key.json


ENTRYPOINT /bin/bash run.sh
