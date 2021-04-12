# Go SDL2 Action-Builder

Github action to crossplatform building with [go_sdl2 veanco](https://github.com/veandco/go-sdl2)

![Build status](https://github.com/ymohl-cl/go_sdl2_actionbuilder/actions/workflows/ci.yml/badge.svg)

[![Sourcegraph](https://sourcegraph.com/github.com/ymohl-cl/go_sdl2_actionbuilder/-/badge.svg?style=flat-square)](https://sourcegraph.com/github.com/ymohl-cl/go_sdl2_actionbuilder?badge)
[![Discord](https://img.shields.io/badge/Discord-%40go_sdl2_action-informational?style=flat-square)](https://discord.gg/UFet9jPxMd)
[![License](http://img.shields.io/badge/license-mit-blue.svg?style=flat-square)](https://raw.githubusercontent.com/ymohl-cl/go_sdl2_actionbuilder/main/LICENSE)

- [Go SDL2 Action-Builder](#go-sdl2-action-builder)
  - [Description](#description)
    - [`Windows building step`](#windows-building-step)
    - [`OSX building step`](#osx-building-step)
    - [`Linux building step`](#linux-building-step)
    - [`Binaries result`](#binaries-result)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
  - [Roadmap](#roadmap)
  - [Contributing](#contributing)
  - [Licence](#licence)

## Description

Generate crossplatform binaries to your Go projects using the [go_sdl2 of veanco package](https://github.com/veandco/go-sdl2)

I found very difficult to compile a project from the same environment to the third biggest platforms(windows, osx and linux). It's for this reason that i make it a public git action &nbsp;:blush:&nbsp;. I will be happy if it is useful to you too &nbsp;:grin:&nbsp;

### `Windows building step`

The lib SDL2 was composed from the [official sources](https://libsdl.org/)

Includes components (x86-64 && i686):

* [image](https://www.libsdl.org/projects/SDL_image/)
* [mixer](https://www.libsdl.org/projects/SDL_mixer/)
* [net](https://www.libsdl.org/projects/SDL_net/)
* [ttf](https://www.libsdl.org/projects/SDL_ttf/)

Use the gcc support compiler to windows [mingw-w64](http://mingw-w64.org/doku.php)

### `OSX building step`

The osx build make it with [osxcross](https://github.com/tpoechtrager/osxcross) and load by default the sdk MacOSX11.1 provide by [Joseluisq](https://github.com/joseluisq/macosx-sdks). Thanks to him &nbsp;:wink:&nbsp;

If you want use an other SDK or an other link to get it, you could to do it with change [the inputs values](#inputs)

The lib SDL2 was composed with the original packages from debian distribution

* libsdl2-dev
* libsdl2-{ttf, gfx, image, mixer, net}-dev

### `Linux building step`

The lib SDL2 was composed with the original packages from debian distribution

* libsdl2-dev
* libsdl2-{ttf, gfx, image, mixer, net}-dev

### `Binaries result`

To more details on how change the default configuration check [inputs section](#inputs)

You need provide a Makefile with the specific rule: 'ci-build' which make as you want and will be call just before the artifact save step.

The logic wants that 'ci-build' run the go build on your project. The following cases works:

``` bash
# windows
<$ CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc GOOS=windows GOARCH=amd64 go build -tags static -ldflags "-s -w" -o <destination-bin> <sources>
```

``` bash
# osx
<$ CGO_ENABLED=1 CC=x86_64-apple-darwin20.2-clang GOOS=darwin GOARCH=amd64 go build -tags static -ldflags "-s -w" -o <destination-bin> <sources>
```

``` bash
# linux
<$ CGO_ENABLED=1 CC=clang GOOS=linux GOARCH=amd64 go build -tags static -ldflags "-s -w" -o <destination-bin> <sources>
```

You can check a [full example implementation here](https://github.com/ymohl-cl/go_sdl2_actionbuilder/tree/main/example).

``` yaml
name: 'CI'

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: Sources-getter
      uses: actions/checkout@v2

    - name: go_sdl2-actionbuilder
      id: go_sdl2-actionbuilder
      uses: ymohl-cl/go_sdl2_actionbuilder@<version> # or master
        with:
          go-version: '1.15.2'

    - name: checker
      run: ls /github/workspace/bin # default location to find your binaries files
```

## Inputs

All inputs are optionnals and default values are define like following (ci past with this values)

``` yaml
# go-version to choice a specific golang version image
# In docker, the image will be start by 'FROM golang:<go-version>'
# It's for this reason was implemented a docker parametrizable
go-version: '1.15.2'
```

``` yaml
# osx-version used to define the MACOSX_DEPLOYMENT_TARGET and the OSX_VERSION_MIN to osxcross build
osx-version: '11.0'
```

``` yaml
# osx-sdk-link is a direct download link get with wget and put in the tarball folder to osxcross build
osx-sdk-link: 'https://github.com/joseluisq/macosx-sdks/releases/download/11.1/MacOSX11.1.sdk.tar.xz'
```

``` yaml
# docker-context to find your project with the Makefile
# don't use '/' prefix because the docker-context is concatenate with the path-workdir when is pass to the container.
# example 1 to registry schema:
# github.com/user/repo/
# - files
# - ...
# - Makefile
docker-context: '.'
# example 2 to registry schema:
# github.com/user/repo/
# - project1
# - - files
# - - ...
# - - Makefile
# - project2
docker-context: 'project1'
```

``` yaml
# artifact-name is the folder copied in the share volume like an artifact to retrieve your binaries and other sources
artifact-name: 'bin'
# after the action, you can find you artifact in /<path-workdir input>/<artifact-name>
```

``` yaml
# path-workdir is the shared volume by github action. Please don't update this parameter or assume to know that you do. I put in input to prevent an eventuel change from github action
path-workdir: '/github/workspace'
```

``` yaml
# docker-name to the container result build
docker-name: 'go_sdl2_actionbuilder'
```

``` yaml
# docker-volume to the share volume
docker-volume: 'go_sdl2_actionbuilder-volume'
```

## Outputs

``` yaml
# config is a default print info about the go_sdl2 build configuration
config: project will be built with go version $GO_VERSION and the osx's sdk version $OSX_VERSION downloaded from $OSX_SDK_LINK
```

## Roadmap

For the moment, the build process take a long time. The next step will add a caching layer to docker.

## Contributing

&nbsp;:grey_exclamation:&nbsp; Use issues for everything

- For a small change, just send a PR.
- For bigger changes open an issue for discussion before sending a PR.
- PR should have:
  - Test case
  - Documentation
  - Example (If it makes sense)
- You can also contribute by:
  - Reporting issues
  - Suggesting new features or enhancements
  - Improve/fix documentation

Thank you &nbsp;:pray:&nbsp;&nbsp;:+1:&nbsp;

## Licence

[MIT](https://github.com/ymohl-cl/go_sdl2_actionbuilder/blob/main/LICENSE)
