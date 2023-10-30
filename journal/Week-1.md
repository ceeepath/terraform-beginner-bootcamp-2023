# Terraform Beginner Bootcamp 2023 - Week-1

## Fixing Tags

[How to Delete Local and Remote Tags on Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

Locall delete a tag
```sh
git tag -d <tag_name>
```

Remotely delete tag

```sh
git push --delete origin tagname
```

Checkout the commit that you want to retag. Grab the sha from your Github history.

```sh
git checkout <SHA>
git tag M.M.P
git push --tags
git checkout main
```

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


## CDN Implementation with AWS CloudFront [1.5.0]

In this Task, we implemented a CDN using `aws_cloudfront_distribution` and `aws_cloudfront_origin_access_control`. We also gave the origin access control a **"read-only"** access permission to access the S3 bucket using `aws_s3_bucket_policy`. I also set all my resource and data block names to **"terratown"** for ease of reference.

### Terraform concepts implemented

To make our .tf files not too long and easily readable, we created a `resource-cdn.tf` to handle the CloudFront configurations and `resource-storage.tf` to handle the s3 configurations. We also implemented two new Terraform concepts; Terraform Data Sources and Terraform Locals.

#### Terraform Data Sources

This allows use to source data from cloud resources.

This is useful when we want to reference cloud resources without importing them.

```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```
[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)


#### Terraform Locals

Locals allows us to define local variables.
It can be very useful when we need transform data into another format and have referenced a varaible.

```tf
locals {
  s3_origin_id = "MyS3Origin"
}
```
[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

We also made use of jsonencode to create the json policy in the locals.tf and referenced it in the resource-storage.tf file.

```tf
> jsonencode({"hello"="world"})
{"hello":"world"}
```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

### Content Type
We had to set the content type of our website files in the `aws_s3_object` resource to enable s3 serve us the webpages when accessed through a browser instead of download it as an attachment.

The content_type argument is used to specify the MIME type of the object stored in an AWS S3 bucket using Terraform. The MIME type is a standard way of indicating the nature and format of a document or file. It can help applications to handle the object appropriately, such as displaying it in a browser or downloading it as an attachment. [Read More Here](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types)


## Content Versioning [1.6.0]

To decide when terraform apply make changes to our website files, we decided to implement content versioning using Terraform data and Terraform Lifecycle Meta Argument.

### Terraform Data [https://developer.hashicorp.com/terraform/language/resources/terraform-data]

The terraform_data resource is useful for storing values which need to follow a manage resource lifecycle, and for triggering provisioners when there is no other logical managed resource in which to place them.

### The lifecycle Meta-Argument [https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle]

The lifecycle meta-argument is a special nested block that can appear within a resource block in Terraform. It allows you to customize some aspects of the resource’s behavior, such as how it is created, updated, replaced, or destroyed. The arguments available within a lifecycle block are `create_before_destroy`, `prevent_destroy`, `ignore_changes`, and `replace_triggered_by`.

In this task, we made use of both `ignore_changes`, and `replace_triggered_by` argument.


## Invalidate CloudFront Distribution [1.7.0]

To remove a file or files from the edge caches before they expire, so that the next time a viewer requests the file, CloudFront returns to the origin to fetch the latest version of the file we had to implement CloudFront Distribution Invalidation.

We made use of Terraform data `triggers_replace` and the `local-exec` provisioner.

### Provisioners [https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax]

Provisioners allow you to execute commands on compute instances eg. a AWS CLI command.
They are not recommended for use by Hashicorp because Configuration Management tools such as Ansible are a better fit, but the functionality exists.

#### Local-exec

This will execute command on the machine running the terraform commands eg. plan apply

```tf
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}
```

[Read More on Local Exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)

#### Remote-exec

This will execute commands on a machine which you target. You will need to provide credentials such as ssh to get into the machine.

```tf
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
[Read More on Remote Exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)

### Heredoc Strings

We learnt about the use of heredoc style in writing multi-line string. For example:

```tf
<<EOT
hello
world
EOT
```

[Read More](https://developer.hashicorp.com/terraform/language/expressions/strings#heredoc-strings)