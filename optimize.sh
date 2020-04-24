#!/bin/bash

find . -type f -name "*.png" -exec pngquant --force --skip-if-larger --output {} --speed 1 --strip --verbose {} \;
find . -type f -name "*.svg" -exec svgcleaner {} {} \;
find . -type f -name "*.svg" -exec svgo --multipass {} \;
