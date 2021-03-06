#!/usr/bin/env bash


set -o errexit


# @info:    Prints warning messages
# @args:    warning-message
echoWarn ()
{
  printf "\033[0;33m$1\033[0m"
}

# @info:    Prints info messages
# @args:    info-message
echoInfo ()
{
  printf "\033[1;34m$1\033[0m\n"
}


# @info:    Prints success messages
# @args:    success-message
echoSuccess ()
{
  printf "\033[0;32m$1\033[0m"
}


echoWarn "Hey, I need some information to help you.\n\n"

echoWarn "Repository to be cloned (GIT URL): "
read REPO_LINK

echoWarn "Correct Email: "
read CORRECT_EMAIL

echoWarn "Correct Name: "
read CORRECT_NAME


echoInfo "\n\nPlease review the information carefully.\nOnce we start, there's no way back!\n\n"

echoInfo "REPO: $REPO_LINK"
echoInfo "CORRECT EMAIL: $CORRECT_EMAIL"
echoInfo "CORRECT NAME: $CORRECT_NAME"

echoWarn "\nDo you want to continue [y/n]? "
read CONTINUE

if [ $CONTINUE != "y" ]; then
    echoWarn "Aborting"
    exit
fi

echoInfo "Continue script execution"

DIR_NAME="git-author-replace-"$(date +%s)


git clone --bare $REPO_LINK $DIR_NAME
cd $DIR_NAME


git filter-branch --env-filter '
CORRECT_NAME="'$CORRECT_NAME'"
CORRECT_EMAIL="'$CORRECT_EMAIL'"

export GIT_COMMITTER_NAME="$CORRECT_NAME"
export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"

export GIT_AUTHOR_NAME="$CORRECT_NAME"
export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"

' --tag-name-filter cat -- --branches --tags

git push --force --tags origin 'refs/heads/*'

cd ..
rm -rf $DIR_NAME

echoSuccess "Done. Operation successfully completed !"