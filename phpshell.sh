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

#find line num for start of first switch
fswitchLineNum=$(egrep -n "^[[:blank:]]*switch[[:blank:]]*(.*)[[:blank:]]*{" ${phpFile} | head -1 | cut -f1 -d :)

#find line num for start of last switch
lswitchLineNum=$(egrep -n "^[[:blank:]]*switch[[:blank:]]*(.*)[[:blank:]]*{" ${phpFile} | tail -1 | cut -f1 -d :)

#copy the case section to a tmp file
sed -n "${fswitchLineNum},${lswitchLineNum} p" ${phpFile} | sed -n "/^[[:blank:]]*case '${changeToEnv}':/,/^[[:blank:]]*break;/p" >> ${tmpFile}

#print else block end in tmp file
echo "}" >> ${tmpFile}

#trim case and break from else block
sed -i'.bak' "/^[[:blank:]]*case.*:/d" ${tmpFile} 
sed -i'.bak' "/^[[:blank:]]*break;/d" ${tmpFile}

#prefix keys by 1
sed -i'.bak' "s/variable_get('/variable_get('1/g" ${tmpFile}

#find line no. of first else
elseLineNum=$(egrep -n "^[[:blank:]]*else {" ${phpFile} | head -1 | cut -f1 -d :)
insAtLine=$(expr ${elseLineNum} - 1)
elseEndLineNum=$(cat -n ${phpFile} | sed -n "${elseLineNum},$ p" | grep } | head -1 | tr -d [[:blank:]]})

#remove contents in first else block
sed -i'.bak' "${elseLineNum},${elseEndLineNum} d" ${phpFile}

#insert new else block
sed -i'.bak' -e "${insAtLine}r ${tmpFile}" ${phpFile}

#clean temp file(s)
rm -f ${tmpFile} ${tmpFile}.bak

else
echo "${changeToEnv} not in ${phpFile}"
exit 1

fi
