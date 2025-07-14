# kickstart.nvim

This repository is my personal fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim),
an amazing starting point to write a custom Neovim configuration. It contains my entire
configuration for Neovim, which has become my main text and code editor. Given some efforts to
configure it and get the hang of it, Neovim comes with all the features of modern IDEs (e.g.
language server, debugger, AI integration, etc.), while being very powerful, light-weight, almost
infinitly customizable, super community-driven with a huge plugin eco-system, and living in the
terminal, meaning it can be installed and used directly on remote machines. All these aspects make
coding with Neovim really much more enjoyable for me, compared to my previous experiences with IDEs.

## Requirements

- [Neovim](https://neovim.io/), obviously

- [git](https://www.git-scm.com/), to clone this repository

- (optional but highly recommended) [fd](https://github.com/sharkdp/fd) and
  [ripgrep](https://github.com/BurntSushi/ripgrep) to search files, directories, or within files

- (optional) [npm](https://www.npmjs.com/) and [Python](https://www.python.org/), especially to
  install external tools managed with [mason.nvim](https://github.com/mason-org/mason.nvim), like
  language servers, formatters, debuggers, etc.

- (optional) a valid [GitHub Copilot](https://github.com/features/copilot) subscription, for
  AI-assisted auto-completion and chat

- (optional) SQL interactive terminal tools (e.g.
  [psql](https://www.postgresql.org/docs/current/app-psql.html)) to interact with an SQL database
  using the database explorer plugin

## Install Neovim

There are a few possibilities to install Neovim, depending on your operating system and your
constraints.

### On MacOS

On MacOS, if you simply want to install the latest version (which should be fine for most), you can
simply use [Homebrew](https://brew.sh/). However, I prefer to have complete control over the version
I use, as it happens that new versions have undesirable behaviors, so I install it from source.

<details>
<summary>With Homebrew</summary>

```bash
# to install the latest stable version:
brew install neovim
# or, to install the nightly version (with the latest features but less stable):
# brew install --HEAD neovim
```

</details>
<details>
<summary>From source</summary>

Download the appropriate Neovim release asset (`nvim-macos-x86_64.tar.gz` in my case) from
[the Neovim release page](https://github.com/neovim/neovim/releases), `cd` in the download location,
and run the following commands:

```bash
xattr -c ./nvim-macos-x86_64.tar.gz
tar xzvf nvim-macos-x86_64.tar.gz
```

Then, create a symbolic link from `nvim` somewhere in your `$PATH` to the
`./nvim-macos-x86_64/bin/nvim` executable. For instance, for Neovim version `x.y.x`, I typically
run:

```bash
mv nvim-macos-x86_64 ~/.local/nvim-macos-x86_64-x_y_z
ln -sf ~/.local/nvim-macos-x86_64-x_y_z/bin/nvim ~/.local/bin/nvim
```

</details>

### On Linux

<details>
<summary>With apt</summary>

```bash
# to install the nightly version (with the latest features but less stable):
apt install software-properties-common
add-apt-repository ppa:neovim-ppa/unstable
apt update
apt install neovim
```

</details>

## Install this configuration

### Backup existing custom configuration

If you already have used Neovim with a custom configuration previously, you might want to back-up
this existing configuration and delete Neovim's temporary files, with the following commands for
instance:

```bash
mv ~/.config/nvim ~/.config/nvim-old
rm -rf ~/.local/share/nvim
```

### Clone this configuration

After having managed any existing Neovim configuration, clone this repository in the Neovim
configuration repository, with:

```bash
git clone --depth=1 https://github.com/cjumel/kickstart.nvim ~/.config/nvim
```

### Open Neovim with the install command

Then, open Neovim with the following install command, which is required only for the first launch:

```bash
nvim +MasonInstallAll
```

This will open Neovim, and the Neovim plugin manager I use,
[lazy.nvim](https://github.com/folke/lazy.nvim), will automatically install all the required Neovim
plugins. Then, the [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) plugin will
install language parsers for [Treesitter](https://tree-sitter.github.io/tree-sitter/), an essential
tool providing a variety of language-specific features, like synthax highlighting or folding, and
the [mason.nvim](https://github.com/mason-org/mason.nvim) plugin will install all the required
language servers, formatters, linters and debuggers.

When notifications stop appearing, this is over and you can quit Neovim by typing the `q` key twice,
to quite the lazy.nvim menu and Neovim succcessively.

### You're done

Then, you're done and you can use Neovim with this custom configuration with the regular command:

```bash
nvim
```
