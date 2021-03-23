package modules

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"

	"github.com/spf13/cobra"
	"golang.org/x/oauth2"
)

var baseUrl = "https://api.github.com"

type UserPlan struct {
	Name          string `json:"name"`
	Space         int64  `json:"space"`
	PrivateRepo   int64  `json:"private_repo"`
	Collaborators int64  `json:"collaborator"`
}

type User struct {
	Login                   string   `json:"login"`
	Id                      int      `json:"id"`
	NodeId                  string   `json:"node_id"`
	AvatarUrl               string   `json:"avatar_url"`
	GravatarId              string   `json:"gravatar_id"`
	Url                     string   `json:"url"`
	HtmlUrl                 string   `json:"html_url"`
	FollowersUrl            string   `json:"followers_url"`
	FollowingUrl            string   `json:"following_url"`
	GistsUrl                string   `json:"gists_url"`
	StarredUrl              string   `json:"starred_url"`
	SubscriptionUrl         string   `json:"subscriptions_url"`
	OrganizationUrl         string   `json:"organizations_url"`
	ReposUrl                string   `json:"repos_url"`
	EventUrl                string   `json:"events_url"`
	RecievedEventsUrl       string   `json:"received_events_url"`
	UserType                string   `json:"type"`
	SiteAdmin               bool     `json:"site_admin"`
	Name                    string   `json:"name"`
	Company                 string   `json:"company"`
	Blog                    string   `json:"blog"`
	Location                string   `json:"location"`
	Email                   string   `json:"email"`
	Hireable                bool     `json:"hireable"`
	Bio                     string   `json:"bio"`
	TwitterUsername         string   `json:"twitter_username"`
	PublicRepos             int64    `json:"public_repos"`
	PublicGist              int64    `json:"public_gists"`
	Followers               int64    `json:"followers"`
	Following               int64    `json:"following"`
	CreatedAt               string   `json:"created_at"`
	UpdatedAt               string   `json:"updated_at"`
	PrivateGist             int64    `json:"private_gists"`
	TotalPrivateRepos       int64    `json:"total_private_repos"`
	OwnedPrivateRepos       int64    `json:"owned_private_repos"`
	DiskUsage               int64    `json:"disk_usage"`
	Collaborators           int64    `json:"collaborators"`
	TwoFactorAuthentication string   `json:"two_factor_authentication"`
	Plan                    UserPlan `json:"plan"`
}

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

// CreateRepo creates a repo connected to users pat
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
	req, err := http.NewRequest("POST", fmt.Sprintf("%s/user/repos", baseUrl), bytes.NewBuffer(reqBody))
	check(err)
	_, err = client.Do(req)
	check(err)
	fmt.Printf("Success: %s was created\n", args[0])
}

// DeleteRepo delete a repo connected to users pat
func DeleteRepo(cmdCtx *cobra.Command, args []string) {
	if len(args) == 0 {
		fmt.Println("Please enter a repo name ex. nere delete dopeRepo")
		os.Exit(1)
	}
	ctx := context.Background()
	ts := oauth2.StaticTokenSource(&oauth2.Token{AccessToken: args[1]})
	client := oauth2.NewClient(ctx, ts)

	userReq, err := http.NewRequest("GET", fmt.Sprintf("%s/user", baseUrl), nil)
	check(err)
	userResp, err := client.Do(userReq)
	check(err)
	body, err := ioutil.ReadAll(userResp.Body)
	check(err)
	user := User{}
	json.Unmarshal(body, &user)
	req, err := http.NewRequest("DELETE", fmt.Sprintf("%s/repos/%s/%s", baseUrl, user.Login, args[0]), nil)
	check(err)
	_, err = client.Do(req)
	check(err)
	fmt.Printf("Success: %s was deleted\n", args[0])
}
