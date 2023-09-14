#!/bin/bash
set -euo pipefail

# run the following in the shell before invoking this script
# export APSTRA_USER="admin"
# export APSTRA_PASS="password"
# export APSTRA_URL="https://host:port"
# export APSTRA_TLS_VALIDATION_DISABLED="" // presence of this variable causes TLS verification to be skipped. An empty string works.

DIE=""
if [ -z "$APSTRA_USER" ]; then echo "must set APSTRA_USER environment variable"; DIE=true; fi
if [ -z "$APSTRA_PASS" ]; then echo "must set APSTRA_PASS environment variable"; DIE=true; fi
if [ -z "$APSTRA_URL" ]; then echo "must set APSTRA_URL environment variable"; DIE=true; fi

if which jq > /dev/null; then :; else echo "script requires jq"; DIE=true; fi

if [ -n "$DIE" ]; then exit; fi

if printenv APSTRA_TLS_VALIDATION_DISABLED > /dev/null; then SKIP_TLS="-k"; fi

echo "authenticating with API..."
CURL_OUT=$(curl $SKIP_TLS -sX POST "$APSTRA_URL/api/aaa/login" -H "accept: application/json" -H "content-type: application/json" -d "{ \"username\": \"$APSTRA_USER\", \"password\": \"$APSTRA_PASS\"}")
if grep "Invalid credentials" <<< $CURL_OUT;
then
  exit 1
fi

TOKEN=$(jq -r '.token' <<< $CURL_OUT)
if [ -z "$TOKEN" ]
then
  echo "failed to get authentication token"
  exit 1
fi

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
DP_FILE="${SCRIPT_DIR}/device_profile.json"
DP_ID=$(jq -r '.id' < "$DP_FILE")
DP_LABEL=$(jq -r '.label' < "$DP_FILE")

echo "checking for device profile ID collision..."
CURL_OUT=$(curl $SKIP_TLS -o /dev/null -sw "%{http_code}\n" "$APSTRA_URL/api/device-profiles/$DP_ID" -H "accept: application/json" -H "AUTHTOKEN: $TOKEN")
if [ $CURL_OUT -ne 404 ]
then
  echo device profile with ID $DP_ID already exists
  exit 1
fi

echo "checking for device profile label collision..."
while read label
do
  if [ "$label" == "$DP_LABEL" ]
  then
    echo device profile with label $DP_LABEL already exists
    exit 1
  fi
done <<< "$(curl $SKIP_TLS -s "$APSTRA_URL/api/device-profiles" -H "accept: application/json" -H "AUTHTOKEN: $TOKEN" | jq -r '.items[].label')"

echo "creating 200G-capable device profile for QFX5220-32CD..."
curl $SKIP_TLS -sX POST "$APSTRA_URL/api/device-profiles" -H "accept: application/json" -H "AUTHTOKEN: $TOKEN" -H "content-type: application/json" -d "@$DP_FILE"
echo