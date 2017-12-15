#!/bin/bash

#takes input in first argument
changeToEnv=$1

#change your input file
phpFile='/Library/WebServer/Documents/action.php'

timeStamp=$(date +"%s")
tmpFile="/tmp/tempfile.${timeStamp}"

#just for testing if script is called by php
#this block can go away later
echo $(date) > /tmp/newtimestamp
echo "Change to env: ${changeToEnv}" >> /tmp/newtimestamp

#only if case for the input environment exists
if egrep -q "^[[:blank:]]*case '${changeToEnv}':" ${phpFile}
then

#backup the php file
cp ${phpFile} ${phpFile}_backup.${timeStamp}

#print start of else block in tmp file
echo "else {" > ${tmpFile}

#find line num for start of last switch
switchLineNum=$(egrep -n "^[[:blank:]]*switch[[:blank:]]*(.*)[[:blank:]]*{" ${phpFile} | tail -1 | cut -f1 -d :)

#copy the case section to a tmp file
sed -n "${switchLineNum},$ p" ${phpFile} | sed -n "/^[[:blank:]]*case '${changeToEnv}':/,/^[[:blank:]]*break;/p" >> ${tmpFile}

#print else block end in tmp file
echo "}" >> ${tmpFile}

#trim case and break from else block
sed -i'.bak' "/^[[:blank:]]*case.*:/d" ${tmpFile} 
sed -i'.bak' "/^[[:blank:]]*break;/d" ${tmpFile}

#find line no. of else
elseLineNum=$(egrep -n "^[[:blank:]]*else {" ${phpFile} | cut -f1 -d :)
insAtLine=$(expr ${elseLineNum} - 1)

#remove contents in else block
sed -i'.bak' "/^[[:blank:]]*else {/,/^[[:blank:]]*}/d" ${phpFile}

#insert new else block
sed -i'.bak' -e "${insAtLine}r ${tmpFile}" ${phpFile}

#clean temp file(s)
rm -f ${tmpFile} ${tmpFile}.bak

else
echo "${changeToEnv} not in ${phpFile}"
exit 1

fi
