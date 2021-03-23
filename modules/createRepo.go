package modules

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/spf13/cobra"
	"golang.org/x/oauth2"
)

var baseUrl = "https://api.github.com/"

type Repo struct {
	Name        string `json:"name"`
	Private     string `jsob:"private"`
	Description string `json:"description"`
}

func check(err error) {
	if err != nil {
		log.Fatalln(err)
	}
}

// CreateRepo creates a repo connected to user account or organization
func CreateRepo(cmdCtx *cobra.Command, args []string) {
	if len(args) == 0 {
		fmt.Println("Please enter a repo name ex. nere create dopeRepo")
		os.Exit(1)
	}
	ctx := context.Background()
	ts := oauth2.StaticTokenSource(&oauth2.Token{AccessToken: args[1]})
	client := oauth2.NewClient(ctx, ts)
	reqBody, err := json.Marshal(Repo{Name: args[0]})
	check(err)
	req, err := http.NewRequest("POST", baseUrl+"user/repos", bytes.NewBuffer(reqBody))
	check(err)
	resp, err := client.Do(req)
	check(err)
	log.Println(resp)
}
