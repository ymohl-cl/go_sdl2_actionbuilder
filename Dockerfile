# Container image that runs your parameterizable docker
# see: https://github.com/JavierZolotarchuk/parameterizable-docker-action-example
FROM alpine:latest

COPY builder.Dockerfile /builder.Dockerfile
COPY entrypoint.sh /entrypoint.sh

# install docker
RUN apk add --update --no-cache docker
RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]