#!/usr/bin/env bash
git pull
git add .
git commit -m ${1:-lc}
git push
