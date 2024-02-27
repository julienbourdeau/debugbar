#!/bin/bash

ruby ./build_fixtures.rb
rm -rf client/dist-demo
(cd client/ && VITE_DEMO_MODE=true npm run build)

if [ -d "../debugbar.dev/source/assets/debugbar" ]; then
  echo
  echo "debugbar.dev found in parent directory"
  echo " -> Copying assets"
  rm -f ../debugbar.dev/source/assets/debugbar/*
  cp ./client/dist-demo/assets/* ../debugbar.dev/source/assets/debugbar/
fi
