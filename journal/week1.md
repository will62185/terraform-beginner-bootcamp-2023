# Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structure

Our Root Module Structure is as follows:

```
PROJECT_ROOT
│
├── main.tf                 # everything else.
├── variables.tf            # stores the structure of input variables.
├── terraform.tfvars        # the data of variables we want to load into our terraform project
├── providers.tf            # defined required providers and their configuration.
├── outputs.tf              # stores our outputs.
└── README.md               # required for root modules.
```

[Terraform Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

### Terraform Cloud Variables

- In Terraform Cloud we can set two kind of variables:
  - Environment Variables - just like local environment variables in bash e.g. `AWS credentials`
  - Terraform Variables - just like we would set in our `terraform.tvars` file.

- We can set Terraform Cloud variables to be sensitive so they are not shown visibly in the UI.

### Loading Terraform Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

#### var flag

- We can use the `-var` flag to set an input variable or override a variable in the tfvars file e.g. `terraform -var user_uuid="my-user_id"`.

#### var-file flag

- TODO: research and document this flag.

#### terraform.tfvars

- This is the default file to load in terraform variables in bulk.

#### auto.tfvars

- TODO: research and document this functionality for terraform cloud.

#### order of terraform variables

- TODO: document which terraform variables takes precedence.

## Dealing with Configuration Drift

#### What happens if we lose our sate file?

- If you lose your statefile, you most likely have to tear down all of your cloud infrastructure manually.
- You can use terraform import, but it won't be available for all cloud resources. You will need to check the terraform providers documentation for which resources support import.

#### Fix Missing Resources with Terraform Import

`terraform import aws_s3_bucket.bucket bucket-name`

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)


#### Fix Manual Configuration

- If someone goes performs CRUD cloud resources through ClickOps.
- If we run Terraform plan with an attempt to put our infrastructure back into the expected state fixing Configuration Drift.

## Fix using Terraform Refresh

```bash
terraform apply -refresh-only -auto-approve
```
(Terraform Refresh)[https://developer.hashicorp.com/terraform/cli/commands/refresh]

## Terraform Modules

### Terraform Module Structure

- It is recommended to place modules in a `modules` directory when locally developing modules, but you can name it whatever you like.

### Passing Input Variables

- We can pass input variables to our module.
- THe module has to declare the terraform variables in its own `variables.tf`

```terraform
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Modules Sources

- Using the source we can import the module from various places:
  - locally
  - Github
  - Terraform Registry

```terraform
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```

[Terraform Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources)
