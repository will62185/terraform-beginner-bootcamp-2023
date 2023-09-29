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