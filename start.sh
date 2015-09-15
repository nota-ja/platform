#!/bin/bash

set -x

source .profile.d/000_apt.sh

mkdir -p web/static/js

echo starting react processor
pushd web/react
npm start &
popd

echo starting compass watch
pushd web/sass-files
compass watch &
popd

echo starting go web server
platform -config config/config.json || nc -l -k $PORT
