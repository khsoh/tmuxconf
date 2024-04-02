#!/usr/bin/env bash

gitTop=$( git rev-parse --show-toplevel 2> /dev/null )
[[ "" == "$gitTop" ]] && echo "$PWD is not a git repository" && exit 0
gitRemotes=$gitTop/.gitremotes
[[ ! -e $gitRemotes ]] && echo "Cannot find .gitremotes file" && exit 0
# if exists added remote repos then exit
[[ "$( git remote -v )" == "" ]] && echo "No remote found in git repository" && exit 0


while read remote; do
    arg=($( echo $remote | cut -w -f 1-3 ))
    if [[ $arg[3] == "(fetch)" ]]; then
	git remote set-url $arg[1] $arg[2]
    fi
done < $gitRemotes

while read remote; do
    arg=($( echo $remote | cut -w -f 1-3 ))
    if [[ $arg[3] == "(push)" ]]; then
	fetchurl=$(git remote get-url $arg[1])
	if [[ $fetchurl != $arg[2] ]]; then
	    git remote set-url --push $arg[1] $arg[2]
	fi
    fi
done < $gitRemotes

