# Terraform Beginner Bootcamp 2023 - Week-1

## Root Module Structure [1.1.0]

The standard module structure is a file and directory layout recommended for reusable modules distributed in separate repositories. The standard module structure expects the layout documented below:

```
PROJECT_ROOT
│
├── main.tf                 # everything else.
├── variables.tf            # stores the structure of input variables
├── terraform.tfvars        # the data of variables we want to load into our terraform project
├── providers.tf            # defined required providers and their configuration
├── outputs.tf              # stores our outputs
└── README.md               # required for root modules
```
[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

### Terraform Cloud Variables

In terraform we can set two kind of variables:
- Enviroment Variables - those you would set in your bash terminal eg. AWS credentials
- Terraform Variables - those that you would normally set in your tfvars file

We can set Terraform Cloud variables to be sensitive so they are not shown visibliy in the UI.

- **Using environment variables**

You can use environment variables to define values for your configuration. One thing to note is that environment variables are prefixed with `TF_VAR_`. For example, to set the value of a variable named **bucket-name**, you would set the environment variable `TF_VAR_bucket-name`. It can be set ths way:

```sh
export TF_VAR_bucket_name="my-s3-bucket"
```

- **Loading Terraform Input Variables**
We can add variables using the variables block directly in the `main.tf` file or using a separate `variables.tf` file. The variable block can be defind this way:

```h
variable "example_var" {
  type    = string
  default = "default_value"
}
```
[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

- **var flag**
We can use the `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user_uuid="my-user_id"`

- **terraform.tvfars**

This is the default filename that Terraform looks for variables. You can also use other filenames and specify them explicitly using the `-var-file` command-line option when running Terraform commands.

- **var-file flag**

To apply your Terraform configuration with the variable values from a specific .tfvars file, you can use the -var-file flag like this: `terraform apply -var-file="vpc-variables.tfvars"`

- ***.auto.tfvars**

Terraform also automatically loads a file named `*.auto.tfvars` if it exists in the current working directory. The behavior of auto.tfvars is essentially the same as that of terraform.tfvars. You can use auto.tfvars to set values for your variables without the need to specify the variable file explicitly when running Terraform commands. If both files exist, Terraform will merge the variable values from both files, with values in auto.tfvars taking precedence if there are any conflicts.

#### order of terraform variables

The order of precedence for variable sources is as follows with later sources taking precedence over earlier ones:

- Environment variables
- Variable blocks
- The terraform.tfvars file
- terraform.tfvars.json file
- Any *.auto.tfvars or *.auto.tfvars.json files
- Any -var and -var-file options on the command line, in the order they are provided.

### Migrating backend from Terraform Cloud to Local
We had to comment the Terraform cloud provider block in the `providers.tf` file. When we ran `terraform init` we got the error:

```bash
Error: Migrating state from Terraform Cloud to another backend is not yet implemented.
```

We fixed this by deleting the `.terraform` directory and the `.terraform.lock.hcl` file.


## Dealing With Configuration Drift [1.2.0]

If someone goes and delete or modifies cloud resource initially created in terraform through ClickOps, we can use terraform import to fix the configuration drift thereby making the state of the resource on the console agree with what is on terraform.

### Terraform Import

Terraform import is a command used to import the current state of an external resource into a Terraform configuration file, enabling you to manage that resource's lifecycle using Terraform. We can either use an import block like:

```h
import {
  to = aws_s3_bucket.bucket
  id = "bucket-name"
}
```

OR

A one-line command `terraform import aws_s3_bucket.bucket bucket-name`.