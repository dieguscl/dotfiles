# My Dotfiles

These are my personal configuration files for **Neovim** and **Tmux**. This repository provides a simple, one-step script to set up a new machine with my preferred development environment.

-----

## Setup

To set up a new machine, clone this repository and run the installation script. The script will automatically install necessary dependencies (like Tmux Plugin Manager) and create the required symbolic links.

```bash
git clone https://github.com/dieguscl/dotfiles.git
cd dotfiles
./install.sh
```

The script will automatically back up any existing configurations to a `~/.dotfiles_backup_...` directory.

-----

## Post-Installation Steps

After the script finishes, a couple of manual steps are required to install the plugins for each application:

  * **Tmux**: Start a `tmux` session and press **`prefix + I`** (your prefix is `Ctrl + Space`) to have TPM fetch and install the plugins listed in `.tmux.conf`.
  * **Neovim**: Simply start `nvim`. The `lazy.nvim` plugin manager will automatically bootstrap itself and install all the necessary plugins.
