#!/bin/bash

# shellcheck disable=SC2181
# shellcheck disable=SC2086

# Check if the device exists
if curl -sS --header "Access-Token: $PUSHBULLET_KEY" "$URI_BASE/devices" | grep $GREP_DEBUG "$PUSHBULLET_DEVICE_NICKNAME" ; then
  log "Device: $PUSHBULLET_DEVICE_NICKNAME found in Pushbullet account"

# If it does not exist, create it
else
  log "Device not found. Creating new device: $PUSHBULLET_DEVICE_NICKNAME"

  curl -sS --header "Access-Token: $PUSHBULLET_KEY" \
     --header 'Content-Type: application/json' \
     --data-binary "{\"icon\":\"desktop\",\"nickname\":\"$PUSHBULLET_DEVICE_NICKNAME\"}" \
     --request POST \
     $CURL_DEBUG \
     "$URI_BASE/devices"

  if curl -sS --header "Access-Token: $PUSHBULLET_KEY" "$URI_BASE/devices" | grep $GREP_DEBUG "$PUSHBULLET_DEVICE_NICKNAME"; then
    log "Successfully created device: $PUSHBULLET_DEVICE_NICKNAME"

  else
    log "Failed to create device: $PUSHBULLET_DEVICE_NICKNAME"
    exit 1
  fi
fi

# Get device ID. This could be done earlier, but it is a little messy. This is easier to read
pushbullet_device_id=$(curl -sS --header "Access-Token: $PUSHBULLET_KEY" "$URI_BASE/devices" |
  jq -c '.devices[] | select(.nickname)' |
  grep "$PUSHBULLET_DEVICE_NICKNAME" |
  jq --raw-output '.iden')

export PUSHBULLET_DEVICE_ID="$pushbullet_device_id"
log "Pushbullet device ID is: $PUSHBULLET_DEVICE_ID"
