#!/bin/bash

rm -rf client/dist
(cd client && npm run build)

echo
echo " -> Copying new assets version to public/debugbar.js"
cp client/dist/assets/debugbar-*.js public/debugbar.js
