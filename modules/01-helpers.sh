#!/bin/bash

function log(){ printf "$1\n" ;}

export URI_BASE="https://api.pushbullet.com/v2"

# Check required environment variables have been set
if [ "$PUSHBULLET_KEY" == '' ] ; then
  log "PUSHBULLET_KEY environment variable not set"
  will_exit=1
fi

if [ "$PUSHBULLET_DEVICE_NICKNAME" == '' ] ; then
  log "PUSHBULLET_DEVICE_NICKNAME environment variable not set"
  will_exit=1
else
  log "Pushbullet device nickname: $PUSHBULLET_DEVICE_NICKNAME"
fi

if [ "$YTDLM_URL" == '' ] ; then
  log "YTDLM_URL environment variable not set"
  will_exit=1
else
  log "Youtube-dl Material URL set to: $YTDLM_URL"
fi

if [ "$YTDLM_KEY" == '' ] ; then
  log "YTDLM_KEY environment variable not set"
  will_exit=1
fi

if [[ $will_exit == 1 ]]; then
  log 'Exiting...'
  exit 1
fi

if [[ "$CLEANUP" != 'FALSE' ]]; then
  log "CLEANUP is enabled"
  export CLEANUP='true'

elif [[ "$CLEANUP" == 'FALSE' ]]; then
  log "CLEANUP is disabled"
  export CLEANUP='false'
fi

if [[ "$SLEEP_TIME" == '' ]]; then
  export SLEEP_TIME='60'
  log "SLEEP_TIME is set to $SLEEP_TIME"
fi

# Set debugging helper variables
DEBUG=${DEBUG,,}

if [ "$DEBUG" == 'true' ] ; then
  log 'Debugging is enabled'

else
  log 'Debugging is disabled'

  export CURL_DEBUG='-o /dev/null'
  export GREP_DEBUG='-q'
fi
