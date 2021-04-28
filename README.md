# Go SDL2 Action-Builder

Github action to crossplatform building with [go_sdl2 veanco](https://github.com/veandco/go-sdl2)

![Build status](https://github.com/ymohl-cl/go_sdl2_actionbuilder/actions/workflows/ci.yml/badge.svg)

[![Sourcegraph](https://sourcegraph.com/github.com/ymohl-cl/go_sdl2_actionbuilder/-/badge.svg?style=flat-square)](https://sourcegraph.com/github.com/ymohl-cl/go_sdl2_actionbuilder?badge)
[![Marketplace](https://img.shields.io/badge/git%20action-marketplace-informational?style=flat-square)](https://github.com/marketplace/actions/go_sdl2-actionbuilder)
[![Discord](https://img.shields.io/badge/Discord-%40go_sdl2_action-informational?style=flat-square)](https://discord.gg/UFet9jPxMd)
[![License](http://img.shields.io/badge/license-mit-blue.svg?style=flat-square)](https://raw.githubusercontent.com/ymohl-cl/go_sdl2_actionbuilder/blob/main/LICENSE)

- [Go SDL2 Action-Builder](#go-sdl2-action-builder)
  - [Description](#description)
    - [`Binaries result`](#binaries-result)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
  - [Roadmap](#roadmap)
  - [Contributing](#contributing)
  - [Licence](#licence)

## Description

Generate crossplatform binaries to your Go projects using the [go_sdl2 of veanco package](https://github.com/veandco/go-sdl2)

I found it very difficult to compile a project from the same environment to the three biggest platforms(windows, osx and linux). It's for this reason that i made it a public git action &nbsp;:blush:&nbsp;. I will be happy if it is useful to you too &nbsp;:grin:&nbsp;

The lib SDL2 was composed with the following components:

- image
- mixer
- net
- ttf

Detail to [windows context](https://github.com/ymohl-cl/docker/tree/main/gosdl2_windows), [osx context](https://github.com/ymohl-cl/docker/tree/main/osxcross).

### `Binaries result`

For more details on how change the default configuration check [inputs section](#inputs)

You need to provide a Makefile with the specific rule: 'ci-build', which makes as you want and will be called just before the artifact saving step.

The logic wants that 'ci-build' runs the go build on your project. The following cases works:

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
          gosdl2-version: '0.0.1'

    - name: checker
      run: ls /github/workspace/bin # default location to find your binaries files
```

## Inputs

All inputs are optionnals and default values are define like following (ci past with this values)

``` yaml
# gosdl2-version to choice a specific godl2 version image
# In docker, the image will be start by 'FROM ymohlcl/gosdl2:<gosdl2-version>'
# It's for this reason was implemented a docker parametrizable
gosdl2-version: 'latest'
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

Nothing for now

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

<a href="https://github.com/ymohl-cl/go_sdl2_actionbuilder/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=ymohl-cl/go_sdl2_actionbuilder" />
</a>

*Made with [contributors-img](https://contrib.rocks)*

## Licence

[MIT](https://github.com/ymohl-cl/go_sdl2_actionbuilder/blob/main/LICENSE)
