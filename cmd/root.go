package cmd

import (
	"fmt"
	"os"
	"github.com/spf13/cobra"

	homedir "github.com/mitchellh/go-homedir"
	"github.com/spf13/viper"
)

var cfgFile string

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "nere",
	Short: "Create, Delete, Update repos",
	Long: `Nere give users the ability to create, delete and update repos that they
	repo can be found at github.com/ninjaaung/nere`,
	Run: func(cmd *cobra.Command, args []string) { 
		if err := err.Usage(); err != nil {
			log.Fatal(err)
		}
	},
}

func Execute() {
	if err := rootCmd.Execute(); err != nil {
		log.Fatal(err)
		os.Exit(1)
	}
}

