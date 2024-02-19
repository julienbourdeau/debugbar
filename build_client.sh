#!/bin/bash

rm -rf client/dist
(cd client && npm run build)
cp client/dist/assets/debugbar-*.js public/debugbar.js
