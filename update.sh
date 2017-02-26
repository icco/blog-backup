#! /bin/bash

RUBY=~/.rvm/environments/ruby-2.4.0

if [[ ! -f $RUBY ]] ; then
  echo "File $RUBY is not there, aborting."
  exit
fi

source $RUBY

git pull
bundle update
git ci Gemfile* -m 'bundle update'
rm _posts/*.md
./grab_all.rb
git add _posts
git ci -m "Backing up posts"
git push
