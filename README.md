# Terraform + Ansible Demo

Configuration files and examples used for demonstrating Terraform and Ansible Automation Platform (AAP) integrations. 

Initially we will demonstrate Terraform and Ansible, individually from the CLI.

This will bring up some challenges around the shared management of:

- credentials (AWS, SSH)
- Ansible inventory
- terraform state file

We will integrate both technologies inside AAP:

- Running the Terraform code individually inside AAP
- Include the Terraform code as part of a larger workflow (day 1 + day 2)
- An approval will be requested to perform the terraform apply
- AAP will manage the Terraform State file in an S3 bucket
- We'll use the Terraform State file as a dynamic inventory in order to post configure EC2 instances

## Requirements

- an AWS account
- an AAP 2.5 with admin rights
- an Ansible Execution Environment that contains `cloud.terraform` and the `terraform` binary (prebuilt for this demo)
- `botocore` & `boto3` python libraries
	```
	pip3 install botocore boto3
	```

## Preparing your AAP and AWS environments

In the `build_demo` folder, replace the vault.yml with your own.

The vault structure should look like this:

```yaml
aap2_host: your-aap-hostname
aap2_username: admin
aap2_password: your-aap-admin-password

aws_access: your-aws-access
aws_secret: your-aws-secret

# no special characters in the name. Must be unique within AWS tenant.
aws_bucket_name: yourbucket

ssh_public_key: "ssh-rsa XYZ"

ssh_private_key: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    YOUR SSH PRIVATE KEY HERE
    -----END OPENSSH PRIVATE KEY-----
```

Run `ansible-playbook 00-prepare.yml`.

This will create all the AAP resources:

- organization
- project
- credentials
  - to access AWS
  - to store the Terraform state file in an S3 bucket
  - the SSH credential to connect to the EC2 instances 
- some jobs
- a workflow that plugs those jobs

Some AWS resources: 

- a key pair that will be used by AAP to post provision EC2 instances
- an S3 bucket that will be used to store the Terraform State file

## When AAP is up and running

Under Automation Execution > Templates, run the workflow.

It will create two EC2 instances (CentOS Stream + Amazon Linux) using Terraform.

When Terraform is done, the state file is stored in the S3 bucket.

The workflow will refresh the inventory (based on the state file).

The next job will install Apache on the instances found in the Terraform state file.

 
