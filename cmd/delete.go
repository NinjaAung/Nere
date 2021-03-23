package cmd

import (
	"github.com/NinjaAung/nere/modules"
	"github.com/spf13/cobra"
)

// deleteCmd represents the delete command
var deleteCmd = &cobra.Command{
	Use:   "delete [repo name]",
	Short: "delete a repo from the account",
	Long:  `delete a repo from the user with PAT`,
	Run: func(cmd *cobra.Command, args []string) {
		modules.DeleteRepo(cmd, args)
	},
}

func init() {
	rootCmd.AddCommand(deleteCmd)
}
