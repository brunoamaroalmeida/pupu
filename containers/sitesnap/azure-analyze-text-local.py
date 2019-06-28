import requests
import sys
import json

# Replace <Subscription Key> with your valid subscription key.
subscription_key = ""
assert subscription_key
text_base_url = "https://westeurope.api.cognitive.microsoft.com/text/analytics/v2.1/"
analyze_url = text_base_url + "sentiment"

text_file =  sys.argv[1]

# Read the image into a byte array
text = open(text_file, "r").read()
headers    = {'Ocp-Apim-Subscription-Key': subscription_key}
response = requests.post(
    analyze_url, headers=headers, data=text)
response.raise_for_status()

analysis = response.json()
print(json.dumps(analysis))
