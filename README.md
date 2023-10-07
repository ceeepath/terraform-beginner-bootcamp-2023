# Terraform Beginner Bootcamp 2023


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

#### Github Lifecycle (Before, Init, Command)

We need to be careful when using the Init because it will not rerun if we restart an existing workspace.

https://www.gitpod.io/docs/configure/workspaces/tasks

### Managing Environment Variables [0.3.0]

#### Listing Environment Variables

You can list all Environment Variables (Env Vars) using the `env` command.
<br>To filter specific env vars, you can use grep. For example, to display all variables with the prefix "AWS_": `env | grep AWS_`

#### Setting and Unsetting Environment Variables
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

#### Displaying Environment Variables
To display the value of an environment variable, use the echo command: `echo $HI`

#### Scope of Environment Variables
When opening new bash terminals in VSCode, they may not inherit env vars from other windows. To persist env vars across all future bash terminals, add them to your bash profile (usually in `.bash_profile`).

#### Persisting Environment Variables in Gitpod
To persist env vars in Gitpod, store them in Gitpod Secrets Storage:

```
gp env HI='world'
```

This will apply the env vars to all future workspaces and bash terminals within those workspaces. You can also set env vars in the .gitpod.yml, but it should only contain non-sensitive env vars.