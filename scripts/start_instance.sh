export ELASTIC_IP=XXX.XXX.XXX.XXX
export EC2USERNAME=ubuntu
export VOLUME1=???
export VOLUME2=???
export PATH_TO_JSON=???
export SPEC_FILE=XXX.json
export PEM_FILE=$HOME/.ssh/aws.pem

echo "requesting a spot instance."
aws ec2 request-spot-instances --spot-price "0.41" --instance-count 1 --type "one-time" --launch-specification file:///$PATH_TO_JSON/$SPEC_FILE

echo "waiting for 4 minutes..."
sleep 240

echo "done waiting associating IP address."
INSTID=`aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" | grep InstanceId | awk '{print $2}' | awk -F\" '{print $2}' | head -1`; aws ec2 associate-address --instance-id $INSTID --public-ip ${ELASTIC_IP}

echo "attaching volumes to instance."
INSTID=`aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" | grep InstanceId | awk '{print $2}' | awk -F\" '{print $2}' | head -1`; aws ec2 attach-volume --volume-id $VOLUME1 --instance-id $INSTID --device /dev/sdf
INSTID=`aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" | grep InstanceId | awk '{print $2}' | awk -F\" '{print $2}' | head -1`; aws ec2 attach-volume --volume-id $VOLUME2 --instance-id $INSTID --device /dev/sdg

echo "mounting volumes on instance. "
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${PEM_FILE} attach_volumes.sh ${EC2USERNAME}@${ELASTIC_IP}:
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ${PEM_FILE} ${EC2USERNAME}@${ELASTIC_IP} "./attach_volumes.sh"

echo "DONE!!"
