package cmd

import (
	"github.com/NinjaAung/nere/modules"
	"github.com/spf13/cobra"
)

// createCmd represents the create command
var createCmd = &cobra.Command{
	Use:   "create [repo name]",
	Short: "This command will create a repository for the user",
	Long:  `create will make a repository with any provided attributes, such as description,name,private or even url`,
	Run: func(cmd *cobra.Command, args []string) {
		modules.CreateRepo(cmd, args)
	},
}

func init() {
	rootCmd.AddCommand(createCmd)
}
