package main

import (
	"fmt"

	"github.com/cezarmathe/install-script/commands"
	"github.com/cezarmathe/install-script/config"
	// "github.com/cezarmathe/install-script/setup"
)

func main() {

	fmt.Println(config.LoadConfig("/home/cezar/Projects/Go/src/github.com/cezarmathe/install-script/config/config_example.yml"))
	commands.WaitForEnter()

}
