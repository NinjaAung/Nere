#!/bin/sh

private=false
description=
username=
reponame=
pat=

usage() # Help and Usage case for the shell
{
    echo "usage: nere [-h help] [-u username ] [-p personal_token] [-r reponame] [-d description] "
}

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
        -t | --Token )          shift   
                                pat=$1
                                ;;
        -p | --private )        shift
                                private=true
                                ;;
    esac
    shift
done

if [ "$pat" != "" ]; then
    username="$username:$pat"
    echo $username
fi


if [ -z $username ]; then  
        read -p "[Username]: " username
fi

if [ -z $reponame ]; then 
    read -p "[Reponame]: " reponame 
fi

curl -s -u $username https://api.github.com/user/repos -d "{\"name\":\"$reponame\", \"private\":$private}"