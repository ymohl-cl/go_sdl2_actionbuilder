package main

import (
	// goui use go_sdl2 driver
	goui "github.com/ymohl-cl/go-ui"
)

func main() {
	var driver goui.GoUI
	var s goui.Scene
	var err error

	if driver, err = goui.New(goui.ConfigUI{
		Window: goui.Window{
			Title:  "test-github-action",
			Width:  42,
			Height: 42,
		},
	}); err != nil {
		panic(err)
	}
	defer driver.Close()

	if s, err = goui.NewScene(); err != nil {
		panic(err)
	}
	defer s.Close()

	if err = driver.Run(s); err != nil {
		panic(err)
	}
}
