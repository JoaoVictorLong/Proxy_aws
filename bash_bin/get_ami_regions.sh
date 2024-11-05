#!/bin/bash

declare -a array=("us-east-1" "us-east-2" "us-west-1" "us-west-2" "ap-south-1" "ap-southeast-1" "ap-southeast-2" "ap-northeast-3" "ap-northeast-1" "ap-northeast-2" "ca-central-1" "eu-central-1" "eu-west-1"  "eu-west-2" "eu-west-3" "eu-north-1" "sa-east-1" ) 

for i in "${array[@]}"
do
    valuer=$(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --region $i | grep Value | cut -d':' -f2 | tr -d ',')
    echo "$i = $valuer" >> ami.txt
done