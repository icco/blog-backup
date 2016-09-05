#! /bin/bash

git pull
rm posts/*.md
./grab_all.rb
git add posts
git ci -m "Backing up posts"
git push
