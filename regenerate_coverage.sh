#!/bin/bash
rm -rf .pio/build/native/*/*/*.gcda
rm -rf coverage/*
pio test -e native
num_runs=1
bugged=1
while [[ -s .pio/build/native/test/test_pid_lib/pid_test.gcda && -s .pio/build/native/test/test_units/units_test.gcda ]] ; do
     if [ $num_runs -ge 50 ] ; then
       bugged=0
       break
     fi
     rm -rf .pio/build/native/*/*/*.gcda
     pio test -e native
     ((num_runs++))
done
lcov --directory .pio/build/native/ --capture --output-file coverage/coverage.info
lcov ${QUIET} --remove "coverage/coverage.info" \
     --output-file "coverage/coverage_trimmed.info" \
     "*src" \
     "*include*" \
     "*libdeps*"
genhtml coverage/coverage_trimmed.info --output-directory coverage/
python -m webbrowser coverage/index.html
if [ $bugged ] ; then
     echo "Problem encountered after $num_runs runs."
else
     echo "No problem encountered after $num_runs runs"
fi