#!/bin/bash


if [ -f report.txt ]; then
rm report.txt
fi

diagnostic=$1
if [ -f $diagnostic ]; then
 tar -zxf $diagnostic
else
 echo "File Not Found! Terminating..." 
 exit
fi


#OSX Code
if [ -d osx_coroner ] ; then
  echo	
  echo "Processing OSX coroner"
  echo
  cd osx_coroner

  	AppVersion=$( awk '/ App.*Version:/ { print $8 }' console.log)
  	echo App Version = $AppVersion >> ../report.txt

  	CoreVersion=$( awk '/ Core.*Version/ { print $8 }' console.log)
  	echo Core Version = $CoreVersion >> ../report.txt

    CPUBrand=$( awk 'BEGIN{FS="|"} /Intel.*GHz/ { print $6 }' console.log)
    echo CPU Information = $CPUBrand >> ../report.txt

  	OSXVersion=$( awk '/ RELEASE/ { print $12; exit; }' console.log)
  	echo Mac OS Version = $OSXVersion >> ../report.txt

    Issue=$( cat issueContext.txt | awk 'BEGIN {FS="\""} {print $4 }')
	   echo Issue = $Issue >> ../report.txt

    Reason=$( cat issueContext.txt | awk 'BEGIN {FS="\""} {print $8 }')
    echo Reason = $Reason >> ../report.txt

    Node=$(cat Lifesize\ Cloud.ini | awk '/curSIP_registrar =/ { printf $3 }')
    echo Registered Node = $Node >> ../report.txt

#On Screen Report - Mac

echo "
********REPORT********

App Version = $AppVersion

Core Version = $CoreVersion

$CPUBrand

Mac OSX Version = $OSXVersion	

Issue Description = $Issue

Reason = $Reason

Registered Nodes = ${Node}

********END********

"


#Windows Code
elif [ -d w32_coroner ] ; then
  echo "Processing WIN32 coroner"
  cd w32_coroner
  	AppVersion=$( awk ' /Lifesize.*version/ { print $5 }' cscwin.log)
  	echo App Version = $AppVersion >> ../report.txt

  	CoreVersion=$( awk ' /MirialCore.*ID/ { print $10; exit; }' previous.log)
  	echo Core Version = $CoreVersion >> ../report.txt

	CPUBrand=$( awk 'BEGIN{FS="|"} /Intel.*GHz/ { print $6 }' previous.log)
	echo CPU Information = $CPUBrand >> ../report.txt

	WinVersion=$( awk '/ RELEASE/ { print $14; exit; }' previous.log)
  	echo Windows OS Version = $WinVersion >> ../report.txt

	Issue=$( cat issueContext.txt | awk 'BEGIN {FS="\""} {print $8 }')
	echo Issue = $Issue >> ../report.txt

	Reason=$( cat issueContext.txt | awk 'BEGIN {FS="\""} {print $4 }')
	echo Reason = $Reason >> ../report.txt

	Node=$(cat LifesizeCloud.ini | awk '/curSIP_registrar =/ { printf $3 }')
	echo Registered Node = $Node >> ../report.txt


#On Screen Report - Windows
echo "
********REPORT********

App Version = $AppVersion

Core Version = $CoreVersion

$CPUBrand

Windows Version = $WinVersion	

Issue Description = $Issue

Reason = $Reason

Registered Nodes = ${Node}

********END********

"


else
  echo "ERROR: coroner contains unrecognized data"
  exit
fi