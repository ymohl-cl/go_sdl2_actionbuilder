# Container image that runs your parameterizable docker
# see: https://github.com/JavierZolotarchuk/parameterizable-docker-action-example
FROM alpine:latest

COPY builder.Dockerfile /runner/builder.Dockerfile
COPY entrypoint.sh /runner/entrypoint.sh

# install docker
RUN apk add --update --no-cache docker
RUN ["chmod", "+x", "/runner/entrypoint.sh"]

ENTRYPOINT ["/runner/entrypoint.sh"]