# Git

## Fetching from the Upstream

Working on this Git repository uses the Fork, Branch and Pull Request 
process. In order to stay in sync with the latest changes it will be
necessary to add the upstream and pull from it occasionally.

Once you have forked and cloned the repository locally

First, define the upsteam.

```sh
git remote add upstream git://github.com/rodericj/CoffUp.git
```

Second, pull from the upstream with the following steps. Note: The `-v` 
makes it verbose to show what the command is doing.

```sh
git fetch origin -v
git fetch upstream -v
git merge upstream/master
```

To simplify running these steps on your Mac you can create an alias
to add to your local `~/.bash_profile` if you are using the default
Bash shell.

```sh
alias pu='git fetch origin -v; git fetch upstream -v; git merge upstream/master'
```

## Submitting a Pull Request

Once you have your own fork and your local copy has been synced up
with the upstream you can submit a [Pull Request][PR]. Before a
PR is submitted the project is expected to build successfully and
run all tests if there any.

[PR]: https://help.github.com/articles/using-pull-requests/
