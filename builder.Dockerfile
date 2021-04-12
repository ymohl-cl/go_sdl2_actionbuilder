ARG GO_VERSION=latest
ARG OSX_VERSION=11.0
ARG OSX_SDK_LINK=https://github.com/joseluisq/macosx-sdks/releases/download/11.1/MacOSX11.1.sdk.tar.xz

ARG ARTIFACT_NAME=bin
ARG PATH_TO_WORKDIR=/github/workspace

## Windows context
FROM golang:$GO_VERSION as windows

WORKDIR /install/window

# download archive
RUN wget https://libsdl.org/release/SDL2-devel-2.0.14-mingw.tar.gz && \
	wget https://www.libsdl.org/projects/SDL_image/release/SDL2_image-devel-2.0.5-mingw.tar.gz && \
	wget https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-devel-2.0.4-mingw.tar.gz && \
	wget https://www.libsdl.org/projects/SDL_net/release/SDL2_net-devel-2.0.1-mingw.tar.gz && \
	wget https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-devel-2.0.15-mingw.tar.gz

# extract archive
RUN tar xf SDL2-devel-2.0.14-mingw.tar.gz && \
	tar xf SDL2_image-devel-2.0.5-mingw.tar.gz && \
	tar xf SDL2_mixer-devel-2.0.4-mingw.tar.gz && \
	tar xf SDL2_net-devel-2.0.1-mingw.tar.gz && \
	tar xf SDL2_ttf-devel-2.0.15-mingw.tar.gz

# add sdl2 libraries
RUN cp -r SDL2-2.0.14/x86_64-w64-mingw32 /usr && \
	cp -r SDL2-2.0.14/i686-w64-mingw32 /usr && \
	cp -r SDL2_mixer-2.0.4/x86_64-w64-mingw32 /usr && \
	cp -r SDL2_mixer-2.0.4/i686-w64-mingw32 /usr && \
	cp -r SDL2_image-2.0.5/x86_64-w64-mingw32 /usr && \
	cp -r SDL2_image-2.0.5/i686-w64-mingw32 /usr && \
	cp -r SDL2_ttf-2.0.15/x86_64-w64-mingw32 /usr && \
	cp -r SDL2_ttf-2.0.15/i686-w64-mingw32 /usr && \
	cp -r SDL2_net-2.0.1/x86_64-w64-mingw32 /usr && \
	cp -r SDL2_net-2.0.1/i686-w64-mingw32 /usr

## OSX context
FROM golang:$GO_VERSION as osx

ARG OSX_VERSION
ARG OSX_SDK_LINK
ARG OSXCROSS_GIT=https://github.com/tpoechtrager/osxcross.git
ENV MACOSX_DEPLOYMENT_TARGET=${OSX_VERSION}
ENV OSX_VERSION_MIN=${OSX_VERSION}

# clone osxcross repo
WORKDIR /usr
RUN git clone ${OSXCROSS_GIT}
# get osx's sdk and put it on tarball forlder
WORKDIR /usr/osxcross/tarballs
RUN wget ${OSX_SDK_LINK}

# update linux dependencies to osxcross build
RUN apt-get update -qq && apt-get install -y cmake \
			patch \
			bzip2 \
			libxml2-dev \
			libssl-dev \
			zlib1g-dev \
			xz-utils \
			clang

# osxcross building
WORKDIR /usr/osxcross
RUN UNATTENDED=yes ./build.sh

## minimal image to crossplatform building (linux context included)
FROM golang:$GO_VERSION as build

# prepare env to ENTRYPOINT work fine aand save the binaries built
ARG ARTIFACT_NAME
ARG PATH_TO_WORKDIR
ENV PATH_TO_WORKDIR=$PATH_TO_WORKDIR
ENV ARTIFACT_NAME=$ARTIFACT_NAME

# get windows mandatories files
COPY --from=windows /usr/x86_64-w64-mingw32 /usr/x86_64-w64-mingw32
COPY --from=windows /usr/i686-w64-mingw32 /usr/i686-w64-mingw32

# get osx mandatories files
# keep the same path than osxcross built env to do not break the generated links
COPY --from=osx /usr/osxcross /usr/osxcross

# get dependencies to build
RUN apt-get update -qq && apt-get install -y libsdl2-dev \
			libsdl2-ttf-dev \
			libsdl2-gfx-dev \
			libsdl2-image-dev \
			libsdl2-mixer-dev \
			libsdl2-net-dev \
			libgtk-3-dev \
			clang \
			mingw-w64

# set binaries in path
ENV PATH=$PATH:/usr/osxcross/target/bin

WORKDIR /go/src/app
COPY . .

# run default rules
RUN make ci-build

ENTRYPOINT mv "/go/src/app/${ARTIFACT_NAME}" "${PATH_TO_WORKDIR}"
