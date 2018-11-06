package commands

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

func ExecuteCommand(command string) {

	cmd := strings.Fields(command)

	out, err := exec.Command(cmd[0], cmd[1:]...).CombinedOutput()

	fmt.Println(string(out))

	if err != nil {
		fmt.Println(err.Error())
		return
	}
}

func ExecuteLocalCommand(name string) {

	workdir, err := os.Getwd()

	if err != nil {
		fmt.Println(err.Error())
		return
	}

	commandname := workdir + "/commands/" + name + ".sh"

	ExecuteCommand(commandname)
}

func WaitForEnter() {
	fmt.Scanln()

}
