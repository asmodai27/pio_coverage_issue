#!/bin/bash
rm -rf .pio/build/native/*/*/*.gcda
rm -rf coverage/*
pio test -e native
while [[ -s .pio/build/native/test/test_pid_lib/pid_test.gcda && -s .pio/build/native/test/test_units/units_test.gcda ]] ; do
     rm -rf .pio/build/native/*/*/*.gcda
     pio test -e native
done
lcov --directory .pio/build/native/ --capture --output-file coverage/coverage.info
lcov ${QUIET} --remove "coverage/coverage.info" \
     --output-file "coverage/coverage_trimmed.info" \
     "*src" \
     "*include*" \
     "*libdeps*"
genhtml coverage/coverage_trimmed.info --output-directory coverage/
python -m webbrowser coverage/index.html
