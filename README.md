# Git-New-Repository-Shell
Shell command that enables a user to create new git repository in the command line | | Terminal

# NERE -- New Repository Shell Command
Using github api create new repositories  straight from the shell using nere 

## Name
nere -- new repository

## Synopsis
nere [-h help] [-u username] [-p personalToken] [-r reponame] [-d description]

## Description
the nere utility creates a repository on the github user (https://github.com) and remote connect to it via the terminal instantly

    A list of options as follows:

    -h will print the help document for the command
    -u takes username input from the user
    -t private token from user's github
    -r takes and creates the input from the user
    -d takes and create the description for the repository
    -p makes the repo private 


## Usage

1. Change the file mode to a executible:
    ```
    ~ chmod 755 nere.sh
    ```
2. Excute with parameter
    ```
    ~ ./nere.sh
    ```
## Implementing into your path
in v2.0 checking if shell is stable