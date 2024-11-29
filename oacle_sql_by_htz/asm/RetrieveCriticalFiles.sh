#!/bin/bash


usage()
{
  echo "Usage: RetriveCriticalFiles.sh -d <failed diskgroup name> -s <ASM diskstring> -o <output directory for storing the retrived files>";
}


## Set Variables

NumArgs=$#

while getopts "d:s:o:h" option;
do
  case "${option}" in
    h) usage;
       exit 0
       ;;
    d)
       dgName=${OPTARG}
       ;;
    s)
       diskString=${OPTARG}
       ;;
    o)
       OutPutDir=${OPTARG}
       ;;
    *) echo "Invalid or missing command line arguments..."
       echo "For Help use: RetriveCriticalFiles.sh -h";
       exit 1
       ;;
   esac
done

if [ $NumArgs -ne 6 ] || [ -z $dgName ] || [ -z $diskString ] || [ -z $OutPutDir ]
then
  echo "Invalid or missing command line arguments..."
  echo "For Help use: RetriveCriticalFiles.sh -h";
  exit 1
fi

## Create the required directories for File restoration


ArchiveLogDir=$OutPutDir/$dgName-amdu-$$-`date +%s`/archivelog
RedoLogDir=$OutPutDir/$dgName-amdu-$$-`date +%s`/redolog
ControlfileDir=$OutPutDir/$dgName-amdu-$$-`date +%s`/controlfile
SpfileDir=$OutPutDir/$dgName-amdu-$$-`date +%s`/spfile
OCRDir=$OutPutDir/$dgName-amdu-$$-`date +%s`/ocr

mkdir -p $ArchiveLogDir
mkdir -p $RedoLogDir
mkdir -p $SpfileDir
mkdir -p $ControlfileDir
mkdir -p $OCRDir


## Populate an Array with the Filetype and the Filenumber of the Files to extract

FileNumbersToExtract=( $(amdu -diskstring $diskString -print $dgName.F1.V0.C1024 -noreport -nodir|awk '
BEGIN {
  FS=":";
}
( $0 ~ /kfffdb\.fileType:/ || /kfbh\.block\.blk:/ ) {
    if ( $1 ~ /kfbh\.block\.blk/ )
    {
       fileNumber = gensub(/[[:space:]]/,"","g",substr($2,1,index($2,";")-1));
    }
    if ( $1 ~ /kfffdb\.fileType/ )
    {
      Filetype=gensub(/[[:space:]]/,"","g",substr($2,1,index($2,";")-1));
      if ( Filetype == "1" || Filetype == "3" || Filetype == "4" || Filetype == "13" || Filetype == "24" )
      {
         print Filetype":"fileNumber
      } 
    }
}
'
) )

## Extract the files populated in the Array

echo "Extracting Critical files from failed diskgroup "$dgName" ... Please wait ..."

NumFiles=${#FileNumbersToExtract[@]}
echo "Number of Critical Files to Extract is :"$NumFiles

for (( i=0 ; i < $NumFiles ; i++ ))
do
  FileTypeNumber=${FileNumbersToExtract[$i]}
  FileType=$(echo $FileTypeNumber|awk -F":" '{print $1}')
  FileNumber=$(echo $FileTypeNumber|awk -F":" '{print $2}')

  if [ $FileType == "1" ]
  then
    echo "Extracting File Type controlfile with File Number "$FileNumber" in directory $ControlfileDir ...."
    amdu -diskstring $diskString -extract $dgName.$FileNumber -noreport -nodir -output $ControlfileDir/"controlfile."$FileNumber
  fi
  if [ $FileType == "3" ]
  then
    echo "Extracting File Type redolog with File Number "$FileNumber" in directory $RedoLogDir ...."
    amdu -diskstring $diskString -extract $dgName.$FileNumber -noreport -nodir -output $RedoLogDir/"redolog."$FileNumber
  fi
  if [ $FileType == "4" ]
  then
    echo "Extracting File Type archivelog with File Number "$FileNumber" in directory $ArchiveLogDir ...."
    amdu -diskstring $diskString -extract $dgName.$FileNumber -noreport -nodir -output $ArchiveLogDir/"archivelog."$FileNumber
  fi
  if [ $FileType == "13" ]
  then
    echo "Extracting File Type spfile with File Number "$FileNumber" in directory $SpfileDir ...."
    amdu -diskstring $diskString -extract $dgName.$FileNumber -noreport -nodir -output $SpfileDir/"spfile."$FileNumber
  fi
  if [ $FileType == "24" ]
  then
    echo "Extracting File Type OCR with File Number "$FileNumber" in directory $OCRDir ...."
    amdu -diskstring $diskString -extract $dgName.$FileNumber -noreport -nodir -output $OCRDir/"ocr."$FileNumber
  fi
done

echo "*******************"
echo "Done Extracting all critical from failed diskgroup "$dgName
