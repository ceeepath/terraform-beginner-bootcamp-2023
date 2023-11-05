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