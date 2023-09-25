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