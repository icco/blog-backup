#! /bin/bash

git pull
./grab_all.rb
git add posts
git ci -m "Backing up posts"
git push
