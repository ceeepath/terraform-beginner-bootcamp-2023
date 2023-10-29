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

### Fix using Terraform Refresh

```sh
terraform apply -refresh-only -auto-approve
```

## Terraform Modules [1.3.0]

### Terraform Module Structure

It is recommend to place modules in a `modules` directory when locally developing modules but you can name it whatever you like.

### Passing Input Variables

We can pass input variables to our module.
The module has to declare the terraform variables in its own variables.tf

```h
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Modules Sources

Using the source we can import the module from various places eg:
- locally
- Github
- Terraform Registry

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```


[Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources)


## Static Website Configuration [1.4.0]

Here we made use of the `aws_s3_bucket_website_configuration` resource to enable and configure static website hosting on our s3. We also made use of the `aws_s3_object` resource to upload our index.html and error.html file to the s3 bucket.

### Terraform **for_each** meta-argument
The `for_each` argument in Terraform allows you to create multiple instances of a resource or module based on the elements of a map or set, instead of writing them individually. It's used to iterate over a collection and generate resource instances dynamically. This is particularly useful when you have multiple similar resources with different configurations or when you want to manage multiple resources using a single declaration. [Read more here](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)

In this task, i used it to copy both **"index.html"** and **"error.html"** files using one resource block, there by making my code portable. For this to work, i made use of a single variable block with type `map(string)` to define the file path. See structure below:

```t
variable "file_path" {
  description = "Path of the index and error document for the website"
  type        = map(string)
}

file_path = {
  index = "/path/to/file"
  error = "/path/to/file"
}

resource "aws_s3_object" "file" {
  for_each = var.file_path
  bucket = aws_s3_bucket.bucket.bucket
  key    = "${each.key}.html"
  source = each.value
  etag = filemd5(each.value)
}
```

### Working with Filesystem in Terraform

#### Fileexists function

This is used to determines whether a file exists at a given path. We used it in this task to validate the website configuration files. [Read more here](https://developer.hashicorp.com/terraform/language/functions/fileexists)

Example:
```h
condition = fileexists(var.file_path.index)
```

#### Filemd5

In Terraform, `filemd5` is a built-in function that calculates the MD5 hash of a file. It can be used to detect changes in the content of a file. It calculates the MD5 hash of a file, and if the content of the file changes, the MD5 hash will also change. The function takes a single argument, which is the path to the file, and returns the MD5 hash as a hexadecimal string.
Example:
```h
value = filemd5(var.file_path)
```
In this task, we used it to detect changes in the index.html and error.html files so it can apply the new changes when we run terraform apply.

#### Path Variable

In terraform there is a special variable called `path` that allows us to reference local paths:
- path.module = get the path for the current module
- path.root = get the path for the root module
[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

```h
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
}
```

### ETags in Cloud Services
Cloud storage services liks s3 bucket often use **"ETags"** to help manage object versioning and to facilitate efficient transfers and synchronization of data. In Terraform, the `etag` attribute is used with some data sources to capture and manage the ETag of a remote resource. In this task, we made use of the ETag attribute to receive a new HASH from `Filemd5` whenever the content of our local website files changes.

Example:
```t
resource "aws_s3_object" "file" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
  etag = filemd5(${path.root}/public/index.html)
}
```