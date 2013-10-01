#!/bin/sh

git checkout heroku; git merge master; git push heroku heroku:master; git checkout master
