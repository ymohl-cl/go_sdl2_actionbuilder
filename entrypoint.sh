#!/bin/sh -l

GO_VERSION=$1
OSX_VERSION=$2
OSX_SDK_LINK=$3
DOCKER_CONTEXT=$4
ARTIFACT_NAME=$5
PATH_TO_WORKDIR=$6
DOCKER_NAME=$7
DOCKER_VOLUME_NAME=$8

echo "::set-output name=config::project will be built with go version $GO_VERSION and the osx's sdk version $OSX_VERSION downloaded from $OSX_SDK_LINK"

docker build -t $DOCKER_NAME \
    --build-arg GO_VERSION=$GO_VERSION \
    --build-arg OSX_VERSION=$OSX_VERSION \
    --build-arg OSX_SDK_LINK=$OSX_SDK_LINK \
    --build-arg ARTIFACT_NAME=$ARTIFACT_NAME \
    --build-arg PATH_TO_WORKDIR=$PATH_TO_WORKDIR \
    -f ./builder.Dockerfile $PATH_TO_WORKDIR/$DOCKER_CONTEXT \
&& docker create -v $PATH_TO_WORKDIR:$PATH_TO_WORKDIR --name $DOCKER_VOLUME_NAME $DOCKER_NAME \
&& docker run --volumes-from $DOCKER_VOLUME_NAME $DOCKER_NAME
