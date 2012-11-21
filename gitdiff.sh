#!/bin/sh
echo $1
echo $2
if [ x"$1" = x/dev/null -o x"$2" = x/dev/null ]; then
        echo "One part of the comparision is empty"
else
#        echo "Launch Diff for $1 ([E]xamdiff,[D]iiffMerge)"
#        read diff
#        if [ x"$diff" = xd -o x"$diff" = xD ]; then
#            "D:/Software/DiffMerge_3_1_0_15888/DiffMerge.exe" "$1" "$2"
#        else
#            if [ x"$diff" = xE -o x"$diff" = xe  ]; then
    "C:/Work/tools/ExamDiff.exe" "$1" "$2"
#            fi
#        fi
fi
echo $diff
