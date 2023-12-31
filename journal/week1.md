# Terraform Beginner Bootcamp 2023 - Week 1

## Fixing Tags

[How to Delete Local and Remote Tags on Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

- Locally delete a tag

```bash
git tag -d <tag_name>
```

- Remotely delete tag

```bash
git push --delete origin tag-name
```

- Checkout the commit that you want to re-tag. Grab the sha from your Github history.

```bash
git checkout <sha>
git tag Major.Minor.Patch
git push --tags
git checkout main
```

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

- When using the `-var` flag from the cli we can specify individual variables

```terraform
terraform apply -var="image_id=ami-abc123"
terraform apply -var='image_id_list=["ami-abc123","ami-def456"]' -var="instance_type=t2.micro"
terraform apply -var='image_id_map={"us-east-1":"ami-abc123","us-east-2":"ami-def456"}'
```

#### terraform.tfvars

- This is the default file to load in terraform variables in bulk. 
  - Also called Variable Definitions files.

- Terraform also automatically loads a number of variable definitions files if they are present:
  - Files named exactly `terraform.tfvars` or `terraform.tfvars.json`.
  - Any files with names ending in `.auto.tfvars` or `.auto.tfvars.json`.

#### auto.tfvars

> This file is designed to hold automatically generated or sensitive variable values.
It is typically not checked into version control systems (e.g., Git) to keep sensitive data, like passwords or API tokens, confidential.
Variables defined in terraform.auto.tfvars will override any values defined in terraform.tfvars.
When using this file, you can generate it dynamically or keep it separate from your main configuration files.

#### order of terraform variables

- Terraform loads variables in the following order, with later sources taking precedence over earlier ones:
  - Environment variables (TF_VAR_variable_name)
  - The terraform.tfvars file, if present.
  - The terraform.tfvars.json file, if present.
  - Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
  - Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)

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

## Considerations when using ChatGPT to write Terraform

- LLMs such as ChatGPT may not be trained on the latest documentation or information about Terraform.

- It may likely produce older examples that could be deprecated. Often affecting providers.

## Working with Files in Terraform

### Fileexists function

- A built in Terraform function to check if a file exists at a given path.

```terraform
condition     = fileexists(var.index_html_filepath)
```

[Terraform File Exists Function](https://developer.hashicorp.com/terraform/language/functions/fileexists)

### Filemd5

[Terraform Filemd5](https://developer.hashicorp.com/terraform/language/functions/filemd5)

### Path Variable

- In terraform there is a special variable called `path` that allows us to reference local paths:
  - `path.module` = get the path for the current module
  - `path.root` = get the path for the root module

[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

```terraform
resource aws_s3_object "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key = "index.html"
  source = "${path.root}/public/index.html"
}
```
## Terraform Locals

- With the locals block we can define local variables. 
- This can be very useful when we need transform data into another format and have it referenced by a variable.

```terraform
locals {
    s3_origin_id = "MyS3Origin"
}
```
[Terraform Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

## Terraform Data Sources

- This allows us to source data from cloud resources 
- It is useful when we want to reference cloud resources without importing them.

```terraform
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```
[Terraform Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with JSON

- We use jsonencode to create the json policy inline in the hcl.

```terraform
> jsonencode({"hello"="world"})
{"hello":"world"}
```
[Terraform jsonencode function](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

### Changing the Lifecycle of Resources

[Terraform Meta Lifecycle Arguments](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

## Terraform Data

> Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

[Terraform Data](https://developer.hashicorp.com/terraform/language/resources/terraform-data)

## Terraform Provisioners

- Provisioners allow you to execute commands on compute instances e.g. an AWS cli command.

- They are not recommended for use by Hashicorp because config management tools such as Ansible are a better fit, but the functionality exists.

> Provisioners are a Last Resort. 😆

[Terraform Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Local-exec

- This will execute a command on the machine running the terraform commands e.g. plan | apply

```Terraform
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}
```

[Terraform Local-exec provisioner](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)

### Remote-exec

- This will execute a command on a machine which you target. You will need to provide credentials such as ssh to get into the machine.

```terraform
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```

[Terraform Remote-exec provisioner](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)

## For Each Expressions

- For each allows us to enumerate over complex data types.

```bash
[for s in var.list : upper(s)]
```

- This is mostly useful when you are creating multiples of a cloud resource and you want to reduce the amount of repetitive terraform code.

[Terraform For Each Expressions](https://developer.hashicorp.com/terraform/language/expressions/for)