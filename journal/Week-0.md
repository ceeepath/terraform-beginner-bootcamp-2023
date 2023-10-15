# Terraform Beginner Bootcamp 2023 - Week-0

- [Semantic Versioning [0.1.0]](#semantic-versioning--010-)
- [Install Terraform CLI [0.2.0]](#install-terraform-cli--020-)
  * [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
    + [Shebang Considerations](#shebang-considerations)
    + [Execution Considerations](#execution-considerations)
    + [Linux Permissions Considerations](#linux-permissions-considerations)
  * [Gitpod Lifecycle (Before, Init, Command)](#github-lifecycle--before--init--command-)
- [Managing Environment Variables [0.3.0]](#managing-environment-variables--030-)
  * [Listing Environment Variables](#listing-environment-variables)
  * [Setting and Unsetting Environment Variables](#setting-and-unsetting-environment-variables)
  * [Displaying Environment Variables](#displaying-environment-variables)
  * [Scope of Environment Variables](#scope-of-environment-variables)
  * [Persisting Environment Variables in Gitpod](#persisting-environment-variables-in-gitpod)
- [AWS CLI Installation [0.4.0]](#aws-cli-installation--040-)
- [Terraform Basics [0.5.0]](#terraform-basics--050-)
  * [Terraform Registry](#terraform-registry)
    + [Random Terraform Provider](#random-terraform-provider)
    + [Terraform Commands](#terraform-commands)
    + [Basic Terraform Files](#basic-terraform-files)
- [AWS S3 Bucket [0.6.0]](#aws-s3-bucket--060-)
  * [Naming Convention](#naming-convention)
- [Terraform Cloud and Remote Backend [0.7.0]](#terraform-cloud-and-remote-backend--070-)
  * [Issues with Terraform Cloud Login and Gitpod Workspace](#issues-with-terraform-cloud-login-and-gitpod-workspace)
  * [Terraform Cloud Variables](#terraform-cloud-variables)
- [Set TFRC Token [0.8.0]](#set-tfrc-token--080-)
- [Set tf alias for Terraform [0.9.0]](#set-tf-alias-for-terraform--090-)


## Semantic Versioning [0.1.0]

This project is going to utilize semantic versioning for its tagging. A more detailed documentation can be found in: [semver.org](https://semver.org/)

The general format:

 **MAJOR.MINOR.PATCH**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Install Terraform CLI [0.2.0]

The terraform CLI installation instruction changed due to gpg keyring changes. Updated installation instructions was gotten from the terraform tutorial on the [website](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

### Refactoring into Bash Scripts

The instructions was made into a bash script instead of dumping the long instructions into the gitpod.yml task file to keep things tidy. The bash script is located at [./bin/install_terraform.sh](./bin/install_terraform.sh).

This provides us with a more convenient method for debugging and enhances the portability for other projects requiring the installation of the Terraform CLI.

#### Shebang Considerations

A Shebang tells the bash script what program will interpet the script. eg. `#!/bin/bash`

Andrew Brown recommended this format for bash: `#!/usr/bin/env bash`.

- for portability for different OS distributions 
-  will search the user's PATH for the bash executable

https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Execution Considerations

When executing the bash script we can use the `./` shorthand notiation to execute the bash script.

eg. `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml  we need to point the script to a program to interpert it.

eg. `source ./bin/install_terraform_cli`

#### Linux Permissions Considerations

In order to make our bash scripts executable we need to change linux permission for the fix to be exetuable at the user mode.

```sh
chmod u+x ./bin/install_terraform_cli
```

alternatively:

```sh
chmod 744 ./bin/install_terraform_cli
```

https://en.wikipedia.org/wiki/Chmod

### Gitpod Lifecycle (Before, Init, Command)

We need to be careful when using the Init because it will not rerun if we restart an existing workspace.

https://www.gitpod.io/docs/configure/workspaces/tasks

## Managing Environment Variables [0.3.0]

### Listing Environment Variables

You can list all Environment Variables (Env Vars) using the `env` command.
<br>To filter specific env vars, you can use grep. For example, to display all variables with the prefix "AWS_": `env | grep AWS_`

### Setting and Unsetting Environment Variables
In the command line, you can set an environment variable using the export command: `export HELLO='world'`

<br>To remove an environment variable, use the unset command: `unset HELLO`

<br>You can also set an env var temporarily for a single command:
```sh
HELLO='world' ./bin/display_message
```

In Bash scripts, you can set env vars without using export, like this:
```sh
#!/usr/bin/env bash

HI='world'

echo $HI
```

### Displaying Environment Variables
To display the value of an environment variable, use the echo command: `echo $HI`

### Scope of Environment Variables
When opening new bash terminals in VSCode, they may not inherit env vars from other windows. To persist env vars across all future bash terminals, add them to your bash profile (usually in `.bash_profile`).

### Persisting Environment Variables in Gitpod
To persist env vars in Gitpod, store them in Gitpod Secrets Storage:

```
gp env HI='world'
```

This will apply the env vars to all future workspaces and bash terminals within those workspaces. You can also set env vars in the .gitpod.yml, but it should only contain non-sensitive env vars.

## AWS CLI Installation [0.4.0]

AWS CLI is installed for the project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)


[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can configure our credentials by setting them as environmental variables both using export and gp env method.

```sh
export AWS_ACCESS_KEY_ID='AKIAIOSFODNN7EXAMPLE'
export AWS_SECRET_ACCESS_KEY='wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
export AWS_DEFAULT_REGION='us-east-1'
```

```sh
gp env AWS_ACCESS_KEY_ID='AKIAIOSFODNN7EXAMPLE'
gp env AWS_SECRET_ACCESS_KEY='wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
gp env AWS_DEFAULT_REGION='us-east-1'
```

We can check if our AWS credentials is configured correctly by running the following AWS CLI command:
```sh
aws sts get-caller-identity
```

If it is succesful you should see a json payload return that looks like this:

```json
{
    "UserId": "AIEAVUO15ZPVHJ5WIJ5KR",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform-bootcamp"
}
```

We'll need to generate AWS CLI credits from IAM User in order to the user AWS CLI.

## Terraform Basics [0.5.0]

### Terraform Registry

Terraform sources their providers and modules from the Terraform registry which is located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** are plugins that enable Terraform to interact with specific cloud or infrastructure platforms, such as AWS, Azure, or GCP.
- **Modules** are reusable, self-contained units of Terraform configuration that contains a set of related resources, variables, and outputs. They help organize and simplify infrastructure code by promoting modularity and reusability.

#### Random Terraform Provider

Random Terraform Providers are a way of using randomness in Terraform. They can generate random values of different types, such as names, passwords, or tokens. These values are stored in the Terraform state and only change when the inputs or keepers change. You can learn more from the [Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random).

#### Terraform Commands

We can see a list of all the Terrform commands by simply typing `terraform`


- **Terraform Init** is a command in Terraform used to initialize a working directory by downloading the necessary providers and modules specified in your configuration. You run it by typing `terraform init`

- **Terraform Plan** is a Terraform command that examines your configuration and infrastructure to predict the changes that will occur when you apply your Terraform code. It provides a detailed report on what Terraform will do, such as creating, updating, or deleting resources, without actually making any changes to the infrastructure. This allows you to review and confirm the intended modifications before applying them. You run it by typing `terraform plan`

- **Terraform Apply** is used to execute the changes specified in your Terraform configuration. It creates, updates, or deletes resources as needed to align your infrastructure with the desired state defined in your code. It's the command you use to make actual changes to your infrastructure based on your Terraform configuration. You run it by typing `terraform apply`. This will run a plan and pass the changeset to be execute by terraform. Apply should prompt yes or no.
If we want to automatically approve an apply we can provide the auto approve flag eg. `terraform apply --auto-approve`

- **Terraform Destroy** is used to tear down and remove the resources defined in your Terraform configuration. You run it by typing `terraform destroy`. Just like `apply`, `destroy` should prompt yes or no but we can provide the auto approve flag to automatically destroy without the confirmation prompt eg. `terraform destroy --auto-approve`

#### Basic Terraform Files

- **Terraform Lock Files** e.g., `.terraform.lock.hcl` contains the locked versioning for the providers or modulues that should be used with this project. The Terraform Lock File **should be committed** to your Version Control System (VSC) eg. Github

- **Terraform State Files** e.g., `.terraform.tfstate` contain information about the current state of your infrastructure.
This file **should not be commited** to your VCS. This file can contain sensentive data. If you lose this file, you lose knowning the state of your infrastructure. `.terraform.tfstate.backup` is the previous state file state.

- **Terraform Directory** `.terraform` directory contains binaries of terraform providers.

## AWS S3 Bucket [0.6.0]

### Naming Convention
AWS S3 bucket names have the following naming conventions:

- **Globally Unique**: Bucket names must be globally unique across all existing S3 bucket names in AWS. This uniqueness is essential to ensure no naming conflicts.

- **Length**: Bucket names must be between 3 and 63 characters in length.

- **Allowed Characters**: Bucket names can consist of lowercase letters, numbers, hyphens (-), and periods (.), with some rules:
    - Names can start and end with lowercase letters or numbers.
    - Names cannot be formatted as IP addresses (e.g., "192.168.1.1").
    - Names with periods (".") are used for SSL certificates and should be avoided for standard bucket names.
    - No Uppercase: Bucket names must be in lowercase, as AWS S3 is case-insensitive for bucket names, but using lowercase is recommended for consistency.
    - No Underscores: Underscores (_) are not allowed; use hyphens (-) instead.


## Terraform Cloud and Remote Backend [0.7.0]

### Issues with Terraform Cloud Login and Gitpod Workspace

When attempting to run `terraform login` it will launch bash a wiswig view to generate a token. However it does not work expected in Gitpod VsCode in the browser.

The workaround is to manually generate a token in Terraform Cloud

```
https://app.terraform.io/app/settings/tokens?source=terraform-login
```

Then create the file manually here:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Provide the following code (replace your token in the file):

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
    }
  }
}
```

### Terraform Cloud Variables

We need to configure our AWS Credentials in Terraform Cloud before running `terraform plan`.

In the Terraform Cloud platform, go to `Settings -> Variable Sets -> Create Variable Set`, input a preferred "name", select "Apply to specific projects and workspaces". Select the preferred project and workspace you want it to be applied to and click on button "Add Variable". Select "Environment variable" option, and fill in the `AWS_ACCESS_KEY_ID` and its value from AWS credential(IAM). Check the "sensitive" checkbox and click on buttom "Add Variable". Do the same for the `AWS_SECRET_ACCESS_KEY` as well as the `AWS_DEFAULT_REGION`. Click on `Create Variable Set` to group the Variable and it should be applied to the workspace. [Read More](https://stackoverflow.com/questions/71906029/terraform-error-configuring-aws-provider-backend-issue)

## Set TFRC Token [0.8.0]

We created a workaround to [0.7.0] using the [bash script](bin/set_tfrc_token.sh) and set the Token from Terraform cloud as an environmental variable `export TERRAFORM_CLOUD_TOKEN='Your_Terraform_Cloud_Token'`.

## Set tf alias for Terraform [0.9.0]

We set an alias for Terraform as "tf" in the ~/.bash_profile file so we can simply run terraform commands using `tf`. We also automated this using a [bash script](./bin/set_tf_alias.sh) that runs any time we start up gitpod by adding it to the gitpod.yaml file.