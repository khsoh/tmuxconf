#!/usr/bin/env bash

gitTop=$( git rev-parse --show-toplevel 2> /dev/null )
[[ "" == "$gitTop" ]] && echo "$PWD is not a git repository" && exit 0
gitRemotes=$gitTop/.gitremotes
[[ ! -e $gitRemotes ]] && echo "Cannot find .gitremotes file" && exit 0
# if exists added remote repos then exit
[[ "$( git remote -v )" == "" ]] && echo "No remote found in git repository" && exit 0


while read remote; do
    arg=($(echo $remote | awk '{print $1"\n"$2"\n"$3}'))
    if [[ "${arg[2]}" == "(fetch)" ]]; then
	git remote set-url ${arg[0]} ${arg[1]}
    fi
done < $gitRemotes

while read remote; do
    arg=($(echo $remote | awk '{print $1"\n"$2"\n"$3}'))
    if [[ "${arg[2]}" == "(push)" ]]; then
	fetchurl=$(git remote get-url ${arg[0]})
	if [[ $fetchurl != ${arg[1]} ]]; then
	    git remote set-url --push ${arg[0]} ${arg[1]}
	fi
    fi
done < $gitRemotes

