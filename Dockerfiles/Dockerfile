FROM alpine:latest

RUN apk -U upgrade
RUN apk add --no-cache bash curl jq

COPY ./ pyd/

RUN chmod +x /pyd/pyd.sh


# ENTRYPOINT [ "/bin/bash", "-l", "-c" ]
CMD [ "/bin/bash", "/pyd/pyd.sh" ]
