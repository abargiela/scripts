#!/bin/bash

#         USAGE:  aws_tool.sh parameter
# 
#   DESCRIPTION:  This simple script will make the initial setup of you aws tools and export your account for future usage.
# 
#        AUTHOR:  Alexandre Bargiela [ alexandre@bargiela.com.br ]
#       COMPANY:  
#       VERSION:  1.0
#       CREATED:  05/2015

AWS_DIR="${HOME}/AWS-tools"
AWS_ACCOUNT="foobar";
ACCESS_KEY=fffffffffffffff
SECRET_KEY=000000000000000
JVM="/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home/"

function setup {
# Begin create directories
if [[ -d ${AWS_DIR} ]]; then
  echo -e "Directory ${AWS_DIR} already exists, it's fine!\n"
else
  echo -e "Creating AWS Tools directory at ${AWS_DIR} \n" ; mkdir  ${AWS_DIR} ${AWS_DIR}/.ec2_keys
fi

if [[ -d ${JVM} ]]; then 
  echo -e "Java check, it's fine! \n"
else
  echo -e  "Please, download and install java
  Linux/MAC: http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/set-up-ec2-cli-linux.html#java_runtime_linux \n "
  exit 1;
fi

cd ${AWS_DIR}
# End create directories

# Begin download tools
if [[ -d ${AWS_DIR}/ec2-api-tools* ]]; then
  echo "EC2 tools  already exists, it's ok!"
else
  EC2_URL="http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip"
  echo "Downloading EC2 Tools..." ; `type -p curl` -s  -O ${EC2_URL}
  `type -p unzip` ec2-api-tools*.zip
  DIRNAME=`ls -latd ec2-api-tools-* | head -1|awk '{print $9}'`
  ln -s ${DIRNAME} ec2-api-tools
fi

if [[ -d  ${AWS_DIR}/ElasticLoadBalancing* ]]; then
  echo "Elastic Load Balancing already  exists, it's ok!"
else
  ELB_URL="http://ec2-downloads.s3.amazonaws.com/ElasticLoadBalancing.zip"
  echo "Downloading ELB Tools..." ; `type -p curl` -s -O ${ELB_URL}
  `type -p unzip` ElasticLoadBalancing*.zip
  DIRNAME=`ls -latd ElasticLoadBalancing-* | head -1|awk '{print $9}'`
  ln -s ${DIRNAME} ElasticLoadBalancing
fi

if [[ -d ${AWS_DIR}/CloudWatch* ]]; then
  echo "Cloud Watch already exists, it's ok!"
else
  CLOUDWATCH_URL="http://ec2-downloads.s3.amazonaws.com/CloudWatch-2010-08-01.zip"
  echo "Downloading CLOUDWATCH Tools..." ; `type -p curl` -s -O ${CLOUDWATCH_URL}
  `type -p unzip` CloudWatch*.zip
  DIRNAME=`ls -latd CloudWatch-* | head -1|awk '{print $9}'`
  ln -s ${DIRNAME} CloudWatch
fi

if [[ -d ${AWS_DIR}/AutoScaling* ]]; then
  echo "Auto Scaling already exists, it's ok!"
else
  AUTOSCALING_URL="http://ec2-downloads.s3.amazonaws.com/AutoScaling-2011-01-01.zip"
  echo "Downloading AUTOSCALING Tools..." ; `type -p curl` -s -O ${AUTOSCALING_URL}
  `type -p unzip` AutoScaling*.zip 
  DIRNAME=`ls -latd AutoScaling-* | head -1|awk '{print $9}'`
  ln -s ${DIRNAME} AutoScaling
fi
# End download tools

echo -e "ALERT: Please, add your AWS .key and .crt at ${AWS_DIR}/.ec2_keys/  
         User the format name: ${USER}-ACCOUNT.key ${USER}-INSTANCE.crt to name your .key and .crt 
         Example, assuming you AWS account name is foobar, your key name should be, ${USER}-foobar.key ${USER}-foobar.crt
         AND dont forget to change in this script the variables: ACCESS_KEY SECRET_KEY with your credentials"
}

function  load {
  # Begin export variables
  echo "Export variables..."
  export JAVA_HOME=/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home/
  
  export EC2_HOME="${AWS_DIR}/ec2-api-tools"
  export PATH="${PATH}:${EC2_HOME}/bin"
  
  export ELB_HOME="${AWS_DIR}/ElasticLoadBalancing"
  export PATH="${PATH}:${ELB_HOME}/bin"

  export CLOUDWATCH_HOME="${AWS_DIR}/CloudWatch"
  export PATH="${PATH}:${CLOUDWATCH_HOME}/bin"

  export AUTO_SCALING_HOME="${AWS_DIR}/AutoScaling"
  export PATH="${PATH}:${AUTO_SCALING_HOME}/bin"
  
  export ACCESS_KEY=${ACCESS_KEY}
  export SECRET_KEY=${SECRET_KEY}
  export EC2_PRIVATE_KEY=${AWS_DIR}/.ec2/${USER}-${AWS_ACCOUNT}.key
  export EC2_CERT=${AWS_DIR}/.ec2/${USER}-${AWS_ACCOUNT}.crt
  # End export variables
exec /bin/bash
}

function help {
  echo -e "
  Usage: aws_tools.sh parameter

  setup\t\t- Initial startup
  ${AWS_ACCOUNT}\t- export your variables about this account" 
}

case $1 in
  setup)
    setup
    ;;
  ${AWS_ACCOUNT})
    load
    ;;
  help)
    help
    ;;
  *)
    echo "Type a valid option or help for help"
    exit 1
    ;;
esac

