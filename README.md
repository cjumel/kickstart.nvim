# kickstart.nvim

This repository is my personal fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim),
an amazing starting point to write a custom Neovim configuration. It contains my entire
configuration for Neovim, which has become my main text and code editor. Given some efforts to
configure it and get the hang of it, Neovim comes with all the features of modern IDEs (e.g.
language server, debugger, AI integration, etc.), while being very powerful, light-weight, almost
infinitly customizable, super community-driven with a huge plugin eco-system, and living in the
terminal, meaning it can be installed and used directly on remote machines. All these aspects make
coding with Neovim really much more enjoyable for me, compared to my previous experiences with IDEs.

## Features

Besides quite standard (but admittedly numerous) plugins and options I tried to set in a very
sensible/not-exotic way, this configuration essentially implements two major features:

- A **modular configuration**, which makes possible to disable some features globally, per-project
  or even per-command. For instance, I can start Neovim in "light mode", which doesn't require a
  [GitHub Copilot](https://github.com/features/copilot) subscription or any of the external tool
  managed with [mason.nvim](https://github.com/williamboman/mason.nvim), thus requiring less
  additional setup. This is convenient when working on a new machine on which I don't want to
  install all the tools my configuration support, but I still want to be able to benefit from the
  simpler features of my configuration.

- **Terminal-wide themes**, with various color schemes I can change at once through a simple shell
  command (`ct`, for "change theme") for the main terminal softwares I use: a terminal emulator
  ([WezTerm](https://wezfurlong.org/wezterm/index.html)), a terminal multiplexer
  ([tmux](https://github.com/tmux/tmux)), and a text and code editor ([Neovim](https://neovim.io/)).
  This makes possible to change the terminal theme and color scheme for instance to adapt to various
  lightning environments, or just to suit my taste of the day.

## Requirements

- [Neovim](https://neovim.io/), obviously

- [git](https://www.git-scm.com/), to clone this repository

- (optional but highly recommended) [fd](https://github.com/sharkdp/fd),
  [ripgrep](https://github.com/BurntSushi/ripgrep) and [eza](https://github.com/eza-community/eza)
  to search files or directories, within files, or preview directories, through the awesome
  [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) plugin

- (optional) [npm](https://www.npmjs.com/) and [Python](https://www.python.org/), especially to
  install external tools managed with [mason.nvim](https://github.com/williamboman/mason.nvim), like
  language servers, formatters, debuggers, etc.

- (optional) a valid [GitHub Copilot](https://github.com/features/copilot) subscription, for
  AI-assisted auto-completion and chat

- (optional) some additional features require external tools (e.g. database interative terminal
  tools for the database explorer plugin), I'm not listing them here but they are mentionned in the
  source code directly as `NOTE` comments

## Install

### Install Neovim

First of all, install [Neovim](https://neovim.io/).

<details>
<summary>MacOS</summary>

```bash
# to install the latest stable version:
brew install neovim
# or, to install the nightly version (with the latest features but less stable):
# brew install --HEAD neovim
```

</details>
<details>
<summary>Ubuntu</summary>

```bash
# to install the nightly version (with the latest features but less stable):
apt install software-properties-common
add-apt-repository ppa:neovim-ppa/unstable
apt update
apt install neovim
```

</details>

### Clone this configuration

Then, if you already have used Neovim previously with a custom configuration, you will want to
back-up this existing configuration and delete Neovim's temporary files, with the following commands
for instance:

```bash
mv ~/.config/nvim ~/.config/nvim-old
rm -rf ~/.local/share/nvim
```

After having managed any existing Neovim configuration, clone this repository in the Neovim
configuration repository, with:

```bash
git clone --depth=1 https://github.com/clementjumel/kickstart.nvim ~/.config/nvim
```

### Install Neovim tools

Finally, open Neovim with the `nvim` command, and the Neovim plugin manager I use,
[lazy.nvim](https://github.com/folke/lazy.nvim), will automatically install all the required Neovim
plugins.

Once the Neovim plugins are installed, enter the `TSInstallInfo` command (type `:` to enter
command-line mode, then the command, and finally, press `Enter`). This will make the
[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) plugin install language
parsers for [Treesitter](https://tree-sitter.github.io/tree-sitter/) (an essential tool providing a
variety of language-specific features, like synthax highlighting, folding, etc.)

With my configuration, Neovim uses a few language-specific external tools, like language servers,
formatters, or debuggers, so we need to install them as well. To do so, enter the `MasonInstallAll`
command. This will run the installation of many tools in the background, and you can check their
progress using the `Mason` command.

Finally, you can then enter the `Copilot setup` command to setup GitHub Copilot credentials.
Alternatively, you can disable the features requiring extra dependencies by using the "light mode" I
implemented with the `NVIM_LIGHT_MODE` environment variable passed as `1` or `true` (e.g. with the
shell command `NVIM_LIGHT_MODE=1 nvim` to start Neovim).

Then, just enter the `q` (or `quit`) command to quit Neovim, and, afterwards, Neovim will be ready
to be used with this custom configuration with a simple `nvim` shell command!
