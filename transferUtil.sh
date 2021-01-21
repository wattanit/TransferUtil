#!/bin/bash
## Big File Transfer Version 0.4
## Author: Wattanit Hotrakool (wattanit@wattanit.com)


# CLI parser check

destination=$1
inputfile=$2
basename=${inputfile##*/}
workdir=$basename.parts
echo $workdir

# check for existing project
if [ -d $workdir ]
then
    echo "Resuming transfer"
else
    echo "Preparing to transfer"
    mkdir $workdir

    # split file to parts
    tar -cvf - $inputfile | split -b 100m - "$workdir/$basename.part"

    # create remote directory
    ssh $destination "mkdir $workdir"
fi

# transfer files
let doneCount=0
for f in $workdir/*
do
    let doneCount++
    echo "Transfering part $doneCount: $f"
    scp $f $destination:$f && rm $f
done

# remote extract
ssh $destination "cat $workdir/* > $basename.tar && tar -xvf $basename.tar && rm $basename.tar && rm -rf $workdir"

# check file integrity
echo "Checking file integriry"

inputmd5=$(md5sum $inputfile)
dstmd5=$(ssh $destination "md5sum $basename")
echo "origin checksum = $inputmd5"
echo "destination checksum = $dstmd5"

if [[ $inputmd5 == $dstmd5 ]]
then
    echo "File check verified"
else
    echo "File currupted. Please retransfer"
fi

# clean up
echo "Cleaning up"
rm -rf $workdir
