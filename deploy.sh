#!/bin/sh

branch_name=$(git symbolic-ref -q HEAD)
branch_name=${branch_name##refs/heads/}
branch_name=${branch_name:-HEAD}

rm -rf public
mimosa build
git checkout gh-pages
rm -rf *.html
find . -type d -not -name 'public' | xargs rm -rf
mv public/* .
rm -rf public
git add . --all
git commit -am "auto build"
git push
git checkout $branch_name