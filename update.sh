#! /bin/bash

RUBY=~/.rvm/environments/ruby-3.2.2

export PKG_CONFIG_PATH="/opt/homebrew/opt/libpq/lib/pkgconfig"
export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"

if [[ ! -f $RUBY ]] ; then
  echo "File $RUBY is not there, aborting."
  exit
fi

source $RUBY

git pull
bundle update
git ci Gemfile* -m 'bundle update'
./grab_all.rb
git add _posts
git ci -m "Backing up posts"
git push
