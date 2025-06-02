# Terraform CLI

Terraform code to deploy a basic infrastructure in AWS


## Preparing your environment


1. Prepare the demo environment based on this [README file](../README.md)

1. Install Terraform

	```bash
	sudo yum install -y yum-utils
	sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
	sudo yum -y install terraform
	```
   
    OR

    ```bash
    curl "https://releases.hashicorp.com/terraform/1.10.4/terraform_1.10.4_linux_amd64.zip" -o "/tmp/terraform.zip"
    sudo unzip /tmp/terraform.zip -d /usr/local/bin
    hash -r
    ```

1. Define your credentials as environment variables

	```
	export AWS_ACCESS_KEY_ID="redacted"
	export AWS_SECRET_ACCESS_KEY="redacted"
	
	```

1. Initialize Terraform

	`terraform init`

1. Create Terraform's plan

	`terraform plan`

1. Deploy resources

	`terraform apply`
