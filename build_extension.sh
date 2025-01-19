#!/bin/bash

rm public/extension.zip
cd client
npm run build:extension
cd dist-extension
rm .DS_Store
zip -r ../../extension.zip ./
