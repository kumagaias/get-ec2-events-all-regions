#!/bin/bash -eu

# Require
# - aws cli
# - jq v1.5 later

# Setup
# $ aws configure --profile example_profile1
# $ aws configure --profile example_profile2

profiles=('example_profile1' 'example_profile2')

# output file settings
output_file=`date '+%Y%m%d_%H%M%I_ec2_events.csv'`
output_file_header='domain,region,start_date_utc,end_date_utc,instance_id,events,description'

# init
results=''

# all profiles loops
for profile in ${profiles[@]}; do
  echo "----- profile ${profile} -----"
  # get all regions names
  regions=`aws ec2 describe-regions --profile ${profiles[0]} | jq '.Regions | .[].RegionName' | tr -d '\r' | tr -d '"'`
  # all regions loops
  for region in `echo ${regions}`; do
    echo "checking ${region}"
    # get instance ids which scheduled events
    instance_raw=`aws ec2 describe-instance-status --profile ${profile} --region ${region} --query "InstanceStatuses[?Events!=null]"`
    instance_ids=`echo ${instance_raw} | jq -r '.[].InstanceId' | tr -d '\r'`
    # all instance ids loops
    for instance_id in `echo ${instance_ids}`; do
      # get events info with the instance id
      # remove " (double quotes) for aws ec2 parse error
      # replace space to _ for IFS
      events_raw=`aws ec2 describe-instance-status --profile ${profile} --region ${region} --instance-ids ${instance_id}`
      events=`echo ${events_raw} | jq -r '.InstanceStatuses[].Events[] | [.NotBefore, .NotAfter, .Code, .Description] | @csv' | tr -d '"' | tr ' ' '_' | tr -d '\r'`
      # all events info loops
      for event in `echo ${events}`; do
        # cut
        date_from=`echo ${event} | cut -d, -f1`
        date_to=`echo ${event} | cut -d, -f2`
        event_name=`echo ${event} | cut -d, -f3`
        event_description=`echo ${event} | cut -d, -f4`
        # get the domain name with the instance id
        domain=`aws ec2 describe-instances --profile ${profile} --region ${region} --instance-ids ${instance_id} --query "Reservations[].Instances[].Tags[?Key=='Name'].Value" | jq -r '.[]|@csv' | tr -d '\r'`
        # make a row
        results+="${domain},${region},${date_from},${date_to},${instance_id},${event_name},${event_description}"
        results+="\n"
      done
    done
  done
done

# output to a file
echo -e "${output_file_header}" > ${output_file}
echo -e "${results}" >> ${output_file}

echo "Completed! Check ${output_file}"
