# kickstart.nvim

This repository is my personal fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim),
an amazing starting point to write a custom Neovim configuration.

This repository contains my entire Neovim configuration, & with it, I use Neovim as my main code &
text editor. Given some efforts to configure & get the hang of it, Neovim comes with all the
features of modern IDEs, while being very powerful, light-weight, almost infinitly customizable, &
living in the terminal (meaning it can be installed and used directly through SSH on remote
machines).

## Requirements

- [git](https://www.git-scm.com/), to clone this repository

- [fd](https://github.com/sharkdp/fd) & [ripgrep](https://github.com/BurntSushi/ripgrep) to search
  files or within them through the
  [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) plugin

- [npm](https://www.npmjs.com/) & [Python](https://www.python.org/), to install external tools, like
  formatters, debuggers, etc.

## Install

If you have had another Neovim setup previously and you want to remove the Neovim temporary files,
or just to re-install Neovim completely from scratch, you can use:

```shell
rm -rf ~/.local/share/nvim
```

<details>
<summary>MacOS</summary>

```shell
# to install the latest stable version:
brew install neovim
# or, to install the nightly version (with the latest features but less stable):
# brew install --HEAD neovim

git clone --depth=1 https://github.com/clementjumel/kickstart.nvim ~/.config/nvim
```

</details>
<details>
<summary>Ubuntu</summary>

```shell
# to install the nightly version (with the latest features but less stable):
apt install software-properties-common
add-apt-repository ppa:neovim-ppa/unstable
apt update
apt install neovim

git clone --depth=1 https://github.com/clementjumel/kickstart.nvim ~/.config/nvim
```

</details>

After the installation of Neovim, open it, for instance with the `nvim` command, then the Neovim
plugin manager, [Lazy.nvim](https://github.com/folke/lazy.nvim), will automatically install the
Neovim plugins. Once they are installed, the
[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) plugin will automatically
install language parsers for [Treesitter](https://tree-sitter.github.io/tree-sitter/). Then, once
all of this is done, you can type in Neovim `:MasonInstallAll` and press `Enter` to install all the
external tools I use. Once this final installation step is over, quit Neovim with `:q` and `Enter`
and next time you open it, everything should be ready to use.
