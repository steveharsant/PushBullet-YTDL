# PushBullet-YTDL

PushBullet-YTDL is a lightweight pure bash service for for YouTube-dl and Pushbullet. PushBullet-YTDL uses [Youtube-DL Material by Tzahi12345](https://github.com/Tzahi12345/YoutubeDL-Material) as the API endpoint to send YouTube-dl requests to and leverages the public Pushbullet API to listen for download requests.

## Features

* Register a device to a given Pushbullet account.
* Listen for pushes to the device registered.
* Extract the URL to the desired download.
* Send a download request to Youtube-DL Material via its internal API.
* Delete a push after it has been successfully downloaded.

## Usage


* Create a Pushbullet account if one does not already exist
* Generate an API key in the Pushbullet web interface
* Run [Youtube-DL Material by Tzahi12345](https://github.com/Tzahi12345/YoutubeDL-Material) either on your host or in a Docker container
* Generate an API key in the Youtube-DL Material setting page
* Either:
  * Set the required environment variables (see below) and run the `pyd.sh` script, ***OR***
  * Pull the Docker container `docker pull ghcr.io/steveharsant/pushbullet_ytdl:latest` (recommended)
  * Run the Docker container with:

```shell
docker run -d \
  --name=pushbullet_ytdl \
  -e PUSHBULLET_DEVICE_NICKNAME=<<PUSHBULLET DEVICE NAME>> \
  -e PUSHBULLET_KEY=<<PUSHBULLET DEVICE API KEY>> \
  -e YTDLM_KEY=<<Youtube-DL Material API KEY>> \
  -e YTDLM_URL=<<URL to Youtube-DL Material. Requires http/https and port number>> \
  --restart unless-stopped \
  ghcr.io/steveharsant/pushbullet_ytdl:latest
```

## Environment Variables

| Variable Name              | Type    | Required | Description                                                                                                           |
|----------------------------|---------|----------|-----------------------------------------------------------------------------------------------------------------------|
| DEBUG                      | Boolean | False    | Set to `TRUE` to enable debugging.                                                                                    |
| PUSHBULLET_DEVICE_NICKNAME | String  | True     | Friendly name for the device running PushBullet-YTDL                                                                  |
| PUSHBULLET_KEY             | String  | True     | API Key for Pushbullet                                                                                                |
| SLEEP_TIME                 | Integer | False    | Change sleep delay between calls (Push bullet free account only allows 500 API calls per month. Default is 60 seconds |
| YTDLM_KEY                  | String  | True     | Youtube-DL Material's API Key                                                                                         |
| YTDLM_URL                  | String  | True     | Youtube-DL Material's URL. Must include `http`/`https` and a port number. ***Do not put a trailing slash!***                     |

## Building

To build the Docker container from a `Dockerfile` use:

* Enter the root directory `cd /root/path/to/repository`
* Build the container in the subdirectory from the root `docker build -t <<tag name>> -f .Dockerfiles/Dockerfile .`

## Development

TO make development easier, it is possible to create a module named ``00-dev_config.sh` in the `modules` directory with environment variables used by PushBullet-YTDL. This file is in both the `.gitignore` and `.dockerignore` files so they won't ever be committed or packaged into the Docker container. Example file is:

```shell
#!/bin/bash

export PUSHBULLET_KEY=
export PUSHBULLET_DEVICE_NICKNAME=
export YTDLM_KEY=
export YTDLM_URL=
export DEBUG=
export SLEEP_TIME=

```

### Required shebang

As this repository is built for Alpine Linux, the required shebang is `#!/bin/bash`. Any other fails when executing.

## Portential Roadmap

* Add audio downloads
* Parallel download requests to Youtube-DL Material
