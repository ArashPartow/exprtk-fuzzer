#
# **************************************************************
# *         C++ Mathematical Expression Toolkit Library        *
# *                                                            *
# * ExprTk Fuzzer Pass                                         *
# * Author: Arash Partow (2018)                                *
# * URL: http://www.partow.net/programming/exprtk/index.html   *
# *                                                            *
# * Copyright notice:                                          *
# * Free use of the Mathematical Expression Toolkit Library is *
# * permitted under the guidelines and in accordance with the  *
# * most current version of the MIT License.                   *
# * http://www.opensource.org/licenses/MIT                     *
# *                                                            *
# **************************************************************
#


#!/usr/bin/env bash


if [ "$#" -ne 1 ]; then
    echo "usage: ./exprtk_fuzzer_pass.sh <expression list file name>"
    exit 1
fi

expression_list=$1

failure_count=0

while IFS= read -r i; do
  echo "${i}" | ./build/apps/exprtk_fuzzer

  ret_code=$?

  if [ $ret_code != 0 ]; then
    ((++failure_count))
    printf "Failure[%d] on input: %s\n" ${failure_count} "${i}"
    printf "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
  fi   

done < <(cat ${expression_list})

printf "Total failures %d\n" ${failure_count}
