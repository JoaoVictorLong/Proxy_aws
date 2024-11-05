#!/bin/bash

declare -a array=("us-east-1" "us-east-2" "us-west-1" "us-west-2" "ap-south-1" "ap-southeast-1" "ap-southeast-2" "ap-northeast-3" "ap-northeast-1" "ap-northeast-2" "ca-central-1" "eu-central-1" "eu-west-1"  "eu-west-2" "eu-west-3" "eu-north-1" "sa-east-1" ) 

for i in "${array[@]}"
do
	echo "Regian: $i"
    	valuer=$( aws ec2 describe-key-pairs --region $i | grep proxy-server-key | cut -d':' -f2 | tr -d ',|""')
    	if [ ! -z $valuer ];then
    	aws ec2 delete-key-pair --key-name $valuer --region $i
    	echo "delete: "$valuer 
    	fi
done
