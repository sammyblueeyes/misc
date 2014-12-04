#!/bin/bash
# Programatically grab all of the Popular Electronics issues
# from the American History archive. Rename them locally to be
# consistent.


function do_get() {
    url="$1/$2"
    echo Getting $url
    wget --random-wait --http-keep-alive $url
    return $?
}

DECADES="50 60 70 80"

for DECADE in $DECADES; do

    for i in {0..9}; do
        year=${DECADE/%0/$i}

        if [ $year -lt 54 -o $year -gt 82 ]; then 
            continue
        fi

        for j in {1..12}; do

            if [ $year -eq 54 -a $j -lt 10 ]; then
                continue
            fi

            if [ $year -eq 82 -a $j -gt 10 ]; then
                continue
            fi

            issue=`printf "%02d" $j`
            file="Pop-19$year-$issue.pdf"
            
            if [ ! -f ./$file ]; then

                path1="http://www.americanradiohistory.com/Archive-Poptronics/${DECADE}s/$year"
                path2="http://www.americanradiohistory.com/Archive-Poptronics/${DECADE}s/19$year"

                do_get $path1 $file
                if [ $? -eq 0 ]; then continue; fi

                do_get $path2 $file
                if [ $? -eq 0 ]; then continue; fi

                # Try alternative file name

                alt_file="Poptronics-19$year-$issue.pdf"
                do_get $path1 $alt_file
                if [ $? -eq 0 ]; then 
                    mv $alt_file $file
                    continue
                fi

                do_get $path2 $alt_file
                if [ $? -eq 0 ]; then 
                    mv $alt_file $file
                    continue
                fi
                exit -1
            fi
        done
    done

done

