#!/bin/sh -l

GOSDL2_VERSION=$1
DOCKER_CONTEXT=$2
ARTIFACT_NAME=$3
PATH_TO_WORKDIR=$4
DOCKER_NAME=$5
DOCKER_VOLUME_NAME=$6

echo "::set-output name=config::project will be built with gosdl2 version $GOSDL2_VERSION."

docker build -t $DOCKER_NAME \
    --build-arg GOSDL2_VERSION=$GOSDL2_VERSION \
    --build-arg ARTIFACT_NAME=$ARTIFACT_NAME \
    --build-arg PATH_TO_WORKDIR=$PATH_TO_WORKDIR \
    -f ./builder.Dockerfile $PATH_TO_WORKDIR/$DOCKER_CONTEXT \
&& docker create -v $PATH_TO_WORKDIR:$PATH_TO_WORKDIR --name $DOCKER_VOLUME_NAME $DOCKER_NAME \
&& docker run --volumes-from $DOCKER_VOLUME_NAME $DOCKER_NAME
