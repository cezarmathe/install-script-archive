package config

import (
	"os"

	"gopkg.in/yaml.v2"
)

type Config struct {
	Boot struct {
		MakeEfiPartitionIfUefiDetected int `yaml:"make_efi_partition_if_uefi_detected"`
	} `yaml:"boot"`

	InternetConnection struct {
		Wifi int `yaml:"wifi"`
	} `yaml:"internet_connection"`

	Partitions struct {
		Swap         int    `yaml:"swap"`
		SwapLocation string `yaml:"swap_location"`
	} `yaml:"partitions"`

	Localization struct {
		Timezone   string `yaml:"timezone"`
		Locale     string `yaml:"locale"`
		LocaleLang string `yaml:"locale_lang"`
	} `yaml:"localization"`

	Networkconfig struct {
		Hostname string `yaml:"hostname"`
	} `yaml:"network_config"`

	Users struct {
		RootPassword string `yaml:"root_password"`
		RegularUsers []struct {
			Username string `yaml:"username"`
			Groups   string `yaml:"groups"`
			Password string `yaml:"password"`
		} `yaml:"regular_users"`
	} `yaml:"users"`

	Packages struct {
		TarballURL string `yaml:"packages_tarball_url"`
	} `yaml:"packages"`

	Bootloader struct {
		InstallLocation string `yaml:"bootloader_install_location"`
	} `yaml:"bootloader"`

	HomedirConfigs struct {
		TarballURL string   `yaml:"homedir_tarball_url"`
		Commands   []string `yaml:"commands"`
	} `yaml:"homedir_configs"`
}

func LoadConfig(filename string) (Config, error) {

	var config Config

	configFile, err := os.Open(filename)
	defer configFile.Close()

	if err != nil {
		return Config{}, err
	}

	yamlParser := yaml.NewDecoder(configFile)
	yamlParser.Decode(&config)

	return config, nil
}
