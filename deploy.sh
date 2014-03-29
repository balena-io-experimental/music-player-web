#!/bin/sh

FILES = "*.html javascripts stylesheets"

branch_name=$(git symbolic-ref -q HEAD)
branch_name=${branch_name##refs/heads/}
branch_name=${branch_name:-HEAD}

rm -rf public
mimosa build
git checkout gh-pages
rm -rf $FILES
mv public/$FILES .
rm -rf public
git add $FILES --all
git commit -am "auto build"
git push
git checkout $branch_name