#
# **************************************************************
# *         C++ Mathematical Expression Toolkit Library        *
# *                                                            *
# * ExprTk Fuzzer (AFL)                                        *
# * Author: Arash Partow (2018)                                *
# * URL: http://www.partow.net/programming/exprtk/index.html   *
# *                                                            *
# * Copyright notice:                                          *
# * Free use of the Mathematical Expression Toolkit Library is *
# * permitted under the guidelines and in accordance with the  *
# * most current version of the MIT License.                   *
# * https://www.opensource.org/licenses/MIT                    *
# *                                                            *
# **************************************************************
#


#!/usr/bin/env bash


###########################################################
# Setup AFL
###########################################################
pushd .
mkdir -p libafl
wget http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz -P libafl/tgz && \
tar -xvzf libafl/tgz/afl-latest.tgz -C libafl

AFL_BASE=libafl/`tar -tzf libafl/tgz/afl-latest.tgz | head -1 | cut -f1 -d"/"`
export AFL_SKIP_CPUFREQ=1

cd ${AFL_BASE}
make clean    && \
make all -j 2 && \
popd
###########################################################



###########################################################
# Generate test cases
###########################################################
mkdir -p test_cases
counter=0
while IFS= read -r i; do
   echo $i > test_cases/`printf "%05d" ${counter}`.txt
   printf "Generating test case: %05d\n" ${counter}
   ((++counter))
done < <(cat base_test_expressions.txt)
###########################################################



###########################################################
# Build the ExprTk Fuzzer and run it using AFL
###########################################################
export CC=${AFL_BASE}/afl-clang
export CXX=${AFL_BASE}/afl-clang++
wget http://partow.net/programming/exprtk/code/exprtk.hpp -P include/
make clean
make V=1 release
TEST_CASES_DIR=test_cases
RESULT_DIR=results

rm -rf ${RESULT_DIR}

NUM_FUZZER_INSTANCES=4

sudo bash -c 'echo core > /proc/sys/kernel/core_pattern'

for ((i = 0; i < ${NUM_FUZZER_INSTANCES}; ++i));
do
   if [ $i -eq 0 ]; then
      nohup ${AFL_BASE}/afl-fuzz -m 1024 -t 30000 -i ${TEST_CASES_DIR} -o ${RESULT_DIR} -M fuzzer00 ./build/apps/exprtk_fuzzer >/dev/null 2>&1 &
      sleep 60
   else
      nohup ${AFL_BASE}/afl-fuzz -m 1024 -t 30000 -i ${TEST_CASES_DIR} -o ${RESULT_DIR} -S `printf "fuzzer%02d" ${i}` ./build/apps/exprtk_fuzzer >/dev/null 2>&1 &
   fi
done
###########################################################
