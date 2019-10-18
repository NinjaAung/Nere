#!/bin/sh


description=null    # Optional Description flag 
private=false       # Private defaulted to false  
LC_CTYPE=C          # Used for input
username=           # Void Username may move to global
reponame=           # Void reponame
pat=                # Personal Access Token or Password may move to globale


# Color List
RED='\x1b[38;5;9m' # Error
GREEN='\x1B[32m' # Success
NC='\x1B[37m' # Return Default

function cleanUp()
{
    echo "\n${RED}Error: Script Canceled"
    exit 2
}

function usage() # Help and Usage case for the shell
{
    echo "usage: nere [-h help] [-u username ]  ${RED}[${NC} [-p password] or [-a auth] ${RED}]${NC}  [-r reponame] [-d description] "
    exit 0
}


trap cleanUp 2 # Aborts Program


while [ "$1" != "" ]; do
    case $1 in
        -h | --help | help)     shift
                                usage
                                ;;
        -u | --username )       shift
                                username=$1
                                ;;
        -r | --reponame )       shift
                                reponame=$1
                                ;;
        -d | --description )    shift
                                description=\"$1\"
                                ;;
        -a | --auth )           shift
                                pat=$1
                                ;;
        -p | --private )        shift
                                private=true
                                continue
                                ;;
    esac
    shift
done


# if $pat has been assigned
if ! [ -z $pat ]; then
    username="$username:$pat"
fi


# Checks if $username has been assign a string yet
while [ -z $username ] || [ "$username" = "" ] || [[ $username = *[![:ascii:]]* ]]; do
        read -p "[Username]: " username
    done


# Checks if $reponame has been assign a string yet
while [ -z $reponame ] || [ "$reponame" = "" ] || [[ $reponame = *[![:ascii:]]* ]]; do
        read -p "[Reponame]: " reponame 
    done


# Remove echo for public push v1.0
echo curl -s -u $username https://api.github.com/user/repos -d "{\"name\":\"$reponame\", \"description\":$description, \"private\":$private}"

# add and remove ! for testing purpose
if  [ -x "$(command -v git)" ]; then
    echo "${green}Sucess: Online Repository made to: $username"
    echo "${red}Error: Git is not installed; will not create a folder"
    exit 1
else
    ####    Git Intialization Repository    ####
    mkdir "$reponame"
    cd ./$reponame
    git init
    touch README.md
    echo "# $Reponame" > README.md
    git add .
    git remote add origin git@github.com:$username/$reponame.git
    git push -u origin master
fi