#!/bin/bash

set -x

source .profile.d/000_apt.sh

mkdir -p web/static/js

sed --in-place=.0 's/^#!\/usr\/bin\/nodejs/#!\/usr\/bin\/env nodejs/g' .apt/usr/bin/npm
sed --in-place=.01 's/require("\.\.\/lib/require("..\/share\/npm\/lib/g' .apt/usr/bin/npm
sed --in-place=.0 "s/\/usr\/share\/node-mime/\/home\/vcap\/app\/.apt\/usr\/share\/node-mime/g" .apt/usr/lib/nodejs/mime.js

pushd $HOME/.apt/usr/bin
ln -s nodejs node
popd

pushd web/react/node_modules/.bin
ln -s ../browserify/bin/cmd.js browserify
ln -s ../envify/bin/envify envify
ln -s ../eslint/bin/eslint.js eslint
ln -s ../jest-cli/bin/jest.js jest
ln -s ../uglify-js/bin/uglifyjs uglifyjs
ln -s ../watchify/bin/cmd.js watchify
popd

echo starting react processor
pushd web/react
NODE_PATH=$HOME/.apt/usr/lib/nodejs:$HOME/.apt/usr/share/npm/node_modules:$PWD/node_modules npm start &
popd

# echo starting compass watch
# pushd web/sass-files
# compass watch &
# popd

echo starting go web server
source .profile.d/go.sh
platform -config config/config.json || nc -l -k $PORT
