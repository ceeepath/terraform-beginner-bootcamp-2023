# Terraform Beginner Bootcamp 2023 - Week 2

## Terratown Mock Server [2.0.0]

### Bundler

Bundler is a package manager for ruby used to manage gem dependencies in a Ruby application. Bundler helps ensure that your project uses the correct versions of these gems and their dependencies. It does so by maintaining a file called a Gemfile, which specifies the gems and their versions required for your project.

#### Executing ruby scripts in the context of bundler

We have to use `bundle exec` to tell future ruby scripts to use the gems we installed. This is the way we set context.

### Gems

Gems are packages or libraries that can be integrated into Ruby projects to provide additional functionality. The Gems to be installed are typically added to the Gemfile in the project files.

#### Installing Gems

You need to create a Gemfile and define your gems in that file.

```rb
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```

Then you need to run the `bundle install` command

This will install the gems on the system globally (unlike nodejs which install packages in place in a folder called node_modules)

A Gemfile.lock will be created to lock down the gem versions used in this project.

### Sinatra

Sinatra is a micro web-framework for ruby to build web-apps.

Its great for mock or development servers or for very simple projects.

You can create a web-server in a single file.

https://sinatrarb.com/

### Running the web server

We can run the web server by executing the following commands:

```rb
bundle install
bundle exec ruby server.rb
```

All of the code for our server is stored in the `server.rb` file.

## Setting up our custom terraform provider [2.1.0]

### CRUD

Terraform Provider resources utilize CRUD.

CRUD stands for Create, Read, Update, and Delete, which are the four fundamental operations for managing resources in a custom Terraform provider:

- **Create:** In the context of a custom Terraform provider, "Create" refers to the ability to define and provision new resources or objects in the infrastructure. It involves specifying the desired state of a resource and using Terraform to create it.

- **Read:** "Read" involves querying and retrieving information about existing resources or objects. Terraform providers allow you to fetch the current state or attributes of resources that have already been provisioned.

- **Update:** "Update" enables you to modify the configuration or attributes of existing resources. You can use Terraform to make changes to resource properties and ensure that the infrastructure aligns with the desired state.

- **Delete:** "Delete" allows you to remove resources that are no longer needed. Terraform can be used to destroy resources that were previously created, effectively removing them from the infrastructure.

These CRUD operations are essential for managing infrastructure resources using Terraform and are a fundamental part of custom Terraform providers, as they define how Terraform interacts with specific APIs or services to create, read, update, and delete resources in those systems.


https://en.wikipedia.org/wiki/Create,_read,_update_and_delete