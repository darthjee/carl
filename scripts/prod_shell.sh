#!/bin/bash

function run() {
  download
  heroku config | grep -v "^===" | sed -e "s/^\([^:]*\): */\1=/g" > .env.production
  clean_env & \
    PRODUCTION_IMAGE=$(docker_url) \
    docker-compose run carl_production /bin/bash
}

function clean_env() {
  sleep 5
  echo "" > .env.production
}

function app_name(){
  echo $(heroku info -s | grep git_url | sed -e "s/.*\///g" | sed -e "s/\.git$//g")
}

function download() {
  docker pull $(docker_url)
}

function docker_url() {
  echo registry.heroku.com/$(app_name)/web
}

run
