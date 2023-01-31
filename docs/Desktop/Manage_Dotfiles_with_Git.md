## Git comes to rescue

In this example, we will use `$HOME/Dotfiles` as the Git repository, but feel free to change it to your needs.

First of all, we will initialize this repository

    git init --bare $HOME/Dotfiles

Then, as all the `git` commands that we will use will refer to this repository, it is advised to create an alias, such as:

    alias dotfiles='/usr/bin/git --git-dir=$HOME/Dotfiles --work-tree=$HOME'

You can add this line to your $SHELL configuration file (`$HOME/.bashrc` if you use [Bash](https://www.gnu.org/software/bash/) or `$HOME/.zshrc` if you use [zsh](https://www.zsh.org/)).

Next, we will configure Git so it will not show all the untracked files. This is required as we use the entire `$HOME` as work tree.

    dotfiles config --local status.showUntrackedFiles no

At that point, you should be able to check the state of this repository:

    dotfiles status

Then you can add your configuration files and commit as you wish. For example, let's add our `.bashrc` :

    dotfiles add .bashrc
    dotfiles commit -m "Added .bashrc"

Now just add a remote repository (your self-hosted Git or a public one) and push your changes to it:

    dotfiles remote add origin git@gitlab.domain.tld:sogal/dotfiles.git
    dotfiles push

## Setup a new machine

Now that you have it all set, let's configure a new system with the dotfiles you have in your repository.

First, clone locally your online repository:

    git clone --bare git@gitlab.domain.tld:sogal/dotfiles.git $HOME/Dotfiles

Again, you have to defined the same alias as before:

    alias dotfiles='/usr/bin/git --git-dir=$HOME/Dotfiles --work-tree=$HOME'

Remember to put it in your $SHELL configuration file.
Now, just apply the changes from the repository you have just cloned to your system:

    dotfiles checkout

If some of the files already exist, you will get an error. This will probably happen with files created by default during the openSUSE installation and user account creation, such as the `$HOME/.bashrc` file, no worries, just rename or delete them.

Now, each time you change your configuration files tracked by Git, remember to commit and push your changes.
