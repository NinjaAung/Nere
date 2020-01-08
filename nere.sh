#!/bin/sh


description=null    # Optional Description flag 
private=false       # Private defaulted to false
delete=false        # Delete defaulted to false 
LC_CTYPE=C          # Used for input
username=           # Void Username may move to global
reponame=           # Void reponame
pat=                # Personal Access Token or Password may move to globle


# Color List
NC='\x1B[37m' # Return Default
RED='\x1b[38;5;9m' # Error
BLUE='\x1b[0;34m' # feeling blue
GREEN='\x1B[32m' # Success

function cleanUp()
{
    echo "\n${RED}Error: Script Canceled"
    exit 0
}

function usage() # Help and Usage case for the shell
{
    echo "usage: nere [-h help] [-u username ]  ${RED}[${NC} [-p password] or [-a auth] ${RED}]${NC}  [-r reponame] [-d description] "
    exit 0
}

function main() 
{
    if $delete; then
        read -p $'Are you very very sure: y/n ' sure
        if [ "$sure" = "y" ]; then
            echo "${BLUE}You're code will miss you ;^;${NC}"
            # need to add a grep for bad credentials as well
            curl -s -u $username -X "DELETE" https://api.github.com/repos/$username/$reponame | grep --s "Not Found" && echo "${RED}Error: The repository: $reponame dosen't exsist" && echo "Check for any misspellings${NC}" && exit 0
            echo "${GREEN}Success:${RED} $reponame${NC} has been deleted from $username"
        else
            echo "Process Canceled"
            exit 0
        fi
    else 
        curl -s -u $username https://api.github.com/user/repos -d "{\"name\":\"$reponame\", \"description\":$description, \"private\":$private}" | grep --s "Bad credentials" && echo "${RED}Error: Bad Credentials${NC}" && exit 0
        
        # remove ! for testing purpose
        if  ! [ -x "$(command -v git)" ]; then
            echo "${GREEN}Sucess: Online Repository made to: ${NC}$username"
            echo "${RED}Error: Git is not installed; will not create a folder"
            exit 1
        else
            ####    Git Intialization Repository    ####
            mkdir "$reponame"
            cd $reponame/
            touch README.md
            echo "# $Reponame" > README.md
            echo "${GREEN}Starting Git Intialization${NC}"
            git init
            git add .
            git commit -m "Intialize Repository"
            git remote add origin git@github.com:$username/$reponame.git
            git push -u origin master
            echo "${GREEN}Success: Finished and Connected To Repository"
        fi
    fi
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
        -r | --reponame | --create )       shift
                                reponame=$1
                                ;;
        --description )         shift
                                description=\"$1\"
                                ;;
        --delete )              shift
                                delete=true
                                reponame=$1
                                continue
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


main
