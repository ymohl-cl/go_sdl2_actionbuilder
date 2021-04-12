BINARY=go-sdl2-builder
BIN_FOLDER=bin

.PHONY: ci-build
ci-build:
	@CGO_ENABLED=1 CC=x86_64-apple-darwin20.2-clang GOOS=darwin GOARCH=amd64 go build -tags static -ldflags "-s -w" -o ${BIN_FOLDER}/${BINARY}.app .
	@echo binary-darwin built !
	@CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc GOOS=windows GOARCH=amd64 go build -tags static -ldflags "-s -w" -o ${BIN_FOLDER}/${BINARY}.exe .
	@echo binary-windows built !
	@CGO_ENABLED=1 CC=clang GOOS=linux GOARCH=amd64 go build -tags static -ldflags "-s -w" -o ${BIN_FOLDER}/${BINARY} .
	@echo binary-linux built !