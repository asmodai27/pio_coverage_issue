#!/bin/bash
rm -rf .pio/build/native
rm -rf coverage/*
pio test -e native
lcov --directory .pio/build/native/ --capture --output-file coverage/coverage.info
lcov ${QUIET} --remove "coverage/coverage.info" \
     --output-file "coverage/coverage_trimmed.info" \
     "*src" \
     "*include*" \
     "*libdeps*"
genhtml coverage/coverage_trimmed.info --output-directory coverage/
python -m webbrowser coverage/index.html
