# kickstart.nvim

This repository is my personal fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim),
an amazing starting point to write a custom Neovim configuration. It contains my entire Neovim
configuration, and, with it, I use Neovim as my main code and text editor.

Given some efforts to configure and get the hang of it, Neovim comes with all the features of modern
IDEs, while being very powerful, light-weight, almost infinitly customizable, super community-driven
(with a truly huge plugin eco-system), and living in the terminal (meaning it can be installed and
used directly through SSH on remote machines).

## Features

Besides quite standard (but admittedly numerous) plugins and options I set in a very sensible way
(of course the definition of "sensible" will differ for everyone), this configuration essentially
implements two major features:

- A modular Neovim configuration, which enables me to disable some features globally, per-directory,
  or per-command. For instance, I can start Neovim in a "light mode", which doesn't require a GitHub
  Copilot subscription, or any of the external tool managed with
  [mason.nvim](https://github.com/williamboman/mason.nvim), thus requiring less external
  dependencies or setup. See the [config module](lua/config/init.lua) for more details on the
  available options.

- Terminal-wide themes, with various color schemes I can change through a simple terminal command
  (`ct`, for "change theme") for all my main terminal softwares, which are a terminal emulator
  (WezTerm), a terminal multiplexer (Tmux), and main my code and text editor (Neovim). I wanted this
  terminal-wide themes feature for two reasons: I couldn't decide which theme I preferred (there are
  many awesome color schemes out there with support for many softwares, like
  [Catppuccin](https://catppuccin.com/), [Rosé Pine](https://rosepinetheme.com/), or
  [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)), but more importantly, I wanted to be
  able to change easily the color schemes I use depending on the brightness of my physical
  environment (e.g. when it's very bright, a light color scheme is a lot better than a dark one).

## Requirements

- [Neovim](https://neovim.io/), obviously

- [git](https://www.git-scm.com/), to clone this repository

- (optional but recommended) [fd](https://github.com/sharkdp/fd) and
  [ripgrep](https://github.com/BurntSushi/ripgrep) to search files or directories, or within files,
  with the awesome [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) plugin

- (optional: not needed in light-mode) [npm](https://www.npmjs.com/) and
  [Python](https://www.python.org/), especially to install external tools managed with
  [mason.nvim](https://github.com/williamboman/mason.nvim), like language servers, formatters,
  debuggers, etc.

- (optional: not needed in light-mode or can be disabled thourgh the custom configuration feature) a
  GitHub Copilot subscription, for AI-assisted auto-completion and chat

## Install

First of all, install [Neovim](https://neovim.io/).

<details>
<summary>MacOS</summary>

```shell
# to install the latest stable version:
brew install neovim
# or, to install the nightly version (with the latest features but less stable):
# brew install --HEAD neovim
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
```

</details>

Then, if you already have used Neovim previously with a custom configuration, you will want to
back-up this existing configuration and delete Neovim's temporary files, with the following commands
for instance:

```shell
mv ~/.config/nvim ~/.config/nvim-old
rm -rf ~/.local/share/nvim
```

After having managed any existing Neovim configuration, clone this repository in the Neovim
configuration repository, with:

```shell
git clone --depth=1 https://github.com/clementjumel/kickstart.nvim ~/.config/nvim
```

Finally, open Neovim with the `nvim` command, and the Neovim plugin manager I use,
[Lazy.nvim](https://github.com/folke/lazy.nvim), will automatically install all the required Neovim
plugins. Once they are installed, the
[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) plugin will automatically
install language parsers for [Treesitter](https://tree-sitter.github.io/tree-sitter/) (an essential
tool providing a variety of language-specific features, like synthax highlighting, folding, etc.)

If you're using the light mode, Neovim is pretty much ready to be used, so skip this paragraph.
Otherwise a few additional steps are required. First, with my setup, Neovim uses a few
language-specific external tools, like language servers, formatters, or debuggers, so we need to
install them. To do so, enter the `MasonInstallAll` command (type `:` to enter command-line mode,
then the command, and finally, press `Enter`). This will run the installation of many tools in the
background, and you can check their progress using the `Lazy` command. Once the installation is
over, you can then enter the `Copilot setup` command to setup GitHub Copilot credentials.

Then, just enter the `q` command (or `quit`) to quit Neovim, and afterwards Neovim will be ready to
be used with this custom configuration through the `nvim` command!
