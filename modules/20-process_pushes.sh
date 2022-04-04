#!/bin/bash

# Loop forever
while :
do

  pushes=$(
    curl -sS --header "Access-Token: $PUSHBULLET_KEY" \
      --data-urlencode active="true" \
      --data-urlencode modified_after="1.4e+09" \
      --get \
      "$URI_BASE/pushes" | jq -c '.pushes[]' | grep "$PUSHBULLET_DEVICE_ID"
      )

  if [[ $pushes == '' ]]; then
    # Sleep for n seconds
    sleep "$SLEEP_TIME"

  else
    # Set IFS to newline to correctly parse the pushes
    IFS=$'\n'

    for push in $pushes
    do

      url=$(echo "$push" | jq --raw-output '.url')
      push_id=$(echo "$push" | jq --raw-output '.iden')

      title=$(curl -sL "$url" | grep -o '<title>.*</title>' | sed -r 's/<title>//g' | sed -r 's/<\/title>//g' | head -1)
      log "Found title: $title. Starting remote download..."

      # If the download is succesful, run cleanup logic
      if curl -sS -XPOST -H "Content-type: application/json" \
              -d "{\"url\": \"$url\"}" "$YTDLM_URL/api/tomp4?apiKey=$YTDLM_KEY" >/dev/null 2>&1

      then log "Successfully processed: $title"

        # If cleanup is enabled, delete the push
        if [[ $CLEANUP == 'true' ]]; then
          if curl --header "Access-Token: $PUSHBULLET_KEY" \
                  --request DELETE \
                  "$URI_BASE/pushes/$push_id" >/dev/null 2>&1;

          then log "Successfully deleted push: $push_id"
          else log "Failed to delete push: $push_id"
          fi

        # If cleanup id disabled, just log a message
        else log "Cleanup is disabled. Leaving push for $title"
        fi

      # If the download failed, log an error
      else log "Failed to download $title"
      fi
    done

    log "Waiting for new pushes..."
  fi
done
