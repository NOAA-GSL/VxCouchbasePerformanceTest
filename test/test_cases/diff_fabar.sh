#!/usr/bin/env bash
for f in $(ls -1 output/*.fabar.out); do diff "output/$(basename $f)" "output-1/$(basename $f)"; done
