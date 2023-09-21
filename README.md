# Terraform Beginner Bootcamp 2023

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