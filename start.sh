#!/bin/bash

set -x

source .profile.d/000_apt.sh

mkdir -p web/static/js

sed --in-place=.0 's/^#!\/usr\/bin\/nodejs/#!\/usr\/bin\/env nodejs/g' .apt/usr/bin/npm
sed --in-place=.01 's/require("\.\.\/lib/require("..\/share\/npm\/lib/g' .apt/usr/bin/npm
sed --in-place=.0 "s/\/usr\/share\/node-mime/\/home\/vcap\/app\/.apt\/usr\/share\/node-mime/g" .apt/usr/lib/nodejs/mime.js

echo starting react processor
pushd web/react
npm start &
popd

# echo starting compass watch
# pushd web/sass-files
# compass watch &
# popd

echo starting go web server
source .profile.d/go.sh
platform -config config/config.json || nc -l -k $PORT
