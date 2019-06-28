import requests
import sys
import json

# Replace <Subscription Key> with your valid subscription key.
subscription_key = ""
assert subscription_key
vision_base_url = "https://westeurope.api.cognitive.microsoft.com/vision/v2.0/"
analyze_url = vision_base_url + "analyze"

# Set image_path to the local path of an image that you want to analyze.
image_path =  sys.argv[1]

# Read the image into a byte array
image_data = open(image_path, "rb").read()
headers    = {'Ocp-Apim-Subscription-Key': subscription_key,
              'Content-Type': 'application/octet-stream'}
params     = {'visualFeatures': 'Categories,Description,Color'}
response = requests.post(
    analyze_url, headers=headers, params=params, data=image_data)
response.raise_for_status()

analysis = response.json()
print(json.dumps(analysis))
