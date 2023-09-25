# Terraform Beginner Bootcamp 2023

## Table of Contents

- [Semantic Versioning](#semantic-versioning-mage)
- [Installing the Terraform CLI](#installing-the-terraform-cli)
  - [Considerations for Terraform CLI install changes](#considerations-for-terraform-cli-install-changes)
  - [Considerations for Linux Distribution](#considerations-for-linux-distribution)

## Semantic Versioning :mage:

This project is going to utilize semantic versioning for its tagging.
[semver.org](https://semver.org/)

The general format:

**MAJOR.MINOR.PATCH**, e.g. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes
 

## Installing the Terraform CLI

### Considerations for Terraform CLI install changes

The Terraform CLI installation instructions have changed due to gpg keyring changes. The original gitpod.yml bash installation was outdated. Referred to the latest install directions from the Terraform Documentation. 

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Considerations for Linux Distribution

This project is built against Ubuntu.
Please consider checking your Linux distribution and change accordingly yo your distribution needs.

[How to check os version in linux command line](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS version:

```bash
$ cat /etc/os-release

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Refactoring into Bash scripts

While fixing the Terraform gpg-key deprecation issue, we noticed the gitpod install script was a huge amount of code. We decided to create a bash script to Install Terraform CLI.

This bash script is located here: [./bin/install_terraform_cli.sh](./bin/install_terraform_cli.sh)

Reasoning: 

- This will keep the Gitpod Task File ([.gitpod.yml](.gitpod.yml)) tidy.
- This allows us an easier way to debug and execute manually Terraform CLI install
- This will allow better portability for other projects that need to install Terraform CLI.

#### Shebang Considerations

A Shebang (pronounced Sha-bang) tells the bash script what program that will interpret the script. e.g. `#!/bin/bash`

ChatGPT recommended this format for bash: `#!/usr/bin/env bash`

Reasoning:

- For portability for different OS distributions.
- Will search the user's PATH for the bash executable.

https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Execution Considerations

When executing the bash script we can use the `./` shorthand notation to execute the bash script.

e.g. `./bin/install_terraform_cli.sh`

If we are using a script in .gitpod.yml we need to point the script to a program to interpret it.

e.g. `source ./bin/install_terraform_cli.sh`

#### Linux Permissions Considerations

In order to make our bash scripts executable we need to change linux permission for the fix to be executable at the user mode.

```bash
$ chmod u+x ./bin/install_terraform_cli.sh
```

Alternatively: 

```bash
$ chmod 744 ./bin/install_terraform_cli.sh
```

https://en.wikipedia.org/wiki/Chmod

### Gitpod Lifecycle (Before, Init, Command)

We need to be careful when using the Init because it will not rerun if we restart an existing workspace.

https://www.gitpod.io/docs/configure/workspaces/tasks


### Working with Env Vars

- We can list out all Environment variables (Env Vars) using the `env` command.
- We can filter specific env vars using grep e.g. `env | grep AWS`

#### Setting and Unsetting Env Vars

- In the terminal we can set using `export HELLO='world'`
- In the terminal we can can unset using `unset HELLO`
- We can set an env var temporarily when just running a command:

```bash
HELLO='world' ./bin/install_terraform_cli.sh
```

- Within a bash script we can set env without writing export:

```bash
#!/usr/bin/env bash

HELLO='world

echo $HELLO
```

## Printing Vars

- We can print an env var using echo e.g. `echo $HELLO`

#### Scoping of Env Vars

- When you open up new bash terminals in VSCode it will n ot be aware of env vars that you have set in another window.
- If you want the env vars to persist across all future bash terminals that are open you need to se env vars in your bash profile. e.g. `.bash_profile`

#### Persisting Env Vars in Gitpod

- We can persist env vars into gitpod by storing them in Gitpod Secrets Storage.

```bash
gp env HELLO='world'
```

- All future workspaces launched will set the env vars for all bash terminals opened in those workspaces.
- You can also set env vars in the `.gitpod.yml` but this should only contain non sensitive values.

### AWS CLI Installation

- AWS cli is installed for the project via the bash script [`./bin/install_aws_cli.sh`](./bin/install_aws_cli.sh)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[AWS CLI ENV VARS](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

- We can check if our AWS credentials are configured correctly by running the following command:

AWS CLI Command:
```bash
aws sts get-caller-identity
```

- If it is successful you should see a json payload return that looks like this:

```json
{
    "UserId": "AKIAIOSFODNN7EXAMPLE",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/tf-beginner-bootcamp"
}
```

- We'll need to generate AWS CLI credentials from AWS IAM in order to use the AWS CLI.


## Terraform Basics

### Terraform Registry

- Terraform sources their providers and modules from the Terraform registry which located at [registry.terraform.io](registry.terraform.io).

- **Providers** are the way you directly interact with an api using terraform. You will be able to create resources using those providers:

```
provider "random" {
  # Configuration options
}
```
[Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random/latest)


- **Modules** are a collection of terraform files, that provides a template of commonly used actions. This will make terraform code modular, portable, and shareable.

## Terraform Console

- We can see a list of all the terraform commands by typing `terraform`.

#### Terraform Init

- For new terraform projects we will run `terraform init` to download binaries for terraform providers.

#### Terraform Plan

- This will generate out a changeset, about the state of our infrastructure and what will be changed.
- We can output this changeset e.g. `terraform plan` to be passed to an apply, but often you can just ignore outputting the plan to a file.

#### Terraform Apply

- This will run a plan and pass the changeset to be executed by terraform e.g. `terraform apply`. Apply should prompt yes or no.

- If we want to automatically approve an apply we can provide the auto approve flag e.g. `terraform apply --auto-approve`

### Terraform Lock Files

- `.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project. 

- The terraform lock file **should be** committed to your Version Control System (VCS) in our case that is Github.

### Terraform State Files

- `.terraform.tfstate` contains information about the current state of your infrastructure.

- The state file **should never** be committed to your Version Control System.

- The state file can contain sensitive data.

- If the file is lost, you will lose the knowing state of your infrastructure.

- `.terraform.tfstate.backup` is the previous state file state.

### Terraform Directory

`.terraform` directory contains binaries of providers.

### Terraform Destroy

`teraform destroy` will destroy resources that terraform knows about.

- Use `--auto-approve` to skip manually approving a plan or destroy

```
terraform apply --auto-approve
```


### Issues with Terraform Cloud Login and Gitpod Workspace

- Issues with getting a token from `terraform login` launches a WYSIWYG browser in the cli that generates a token. Gitpod does not handle that process
gracefully.

- We had to manually generate the token in the Terraform Cloud Gui, create and open the file, and then paste in the token.

```bash
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
``` 

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR_TERRAFORM_CLOUD_TOKEN"
    }
  }
}
```

[terraform-cloud-token](https://app.terraform.io/app/settings/tokens?source=terraform-login)

- We have automated the process of creating the Terraform credentials file, using a workaround with the following bash script [bin/generate_tfrc_credentials.sh](bin/generate_tfrc_credentials.sh)

- Additionally, we have generated a longer living Terraform API token.