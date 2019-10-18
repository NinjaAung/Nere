#!/bin/sh

private=        # Private defaulted to false
description=    # Optional Description flag    
username=       # Void Username may move to global
reponame=       # Void reponame
pat=            # Personal Access Token or Password may move to globale


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
    echo "usage: nere [-h help] [-u username ]  [ [-p password] or [-a auth] ]  [-r reponame] [-d description] "
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
                                description=$1
                                ;;
        -a | - | --auth )           shift
                                pat=$1
                                ;;
        -p | --private )        shift
                                private=true
                                continue
                                shift
    esac
    shift
done


# if $pat has been assigned
if ! [ -z $pat ]; then
    username="$username:$pat"
    echo $username
fi


# Checks if $username has been assign a string yet
if [ -z $username ]; then 
        read -p "[Username]: " username
fi


# Checks if $reponame has been assign a string yet
if [ -z $reponame ]; then 
    read -p "[Reponame]: " reponame 
fi


# Remove echo for public push v1.0
echo curl -s -u $username https://api.github.com/user/repos -d "{\"name\":\"$reponame\", \"private\":$private}"