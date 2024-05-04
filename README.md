# kickstart.nvim

This is my personal fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

Thanks to it, I use Neovim as my main text & code editor. Given some efforts to configure it & get
the hang of it, it comes with all the features of modern IDEs, while being very light-weight, almost
infinitly customizable, and living in the terminal (meaning it can be installed and used directly
through SSH on remote machines).

**Requirements:**

- `git`
- `ripgrep` & `fd` (optional, for Telescope plugin)
- `npm` & `python` (optional, for some external tools)

**Install:**

<details>
<summary>MacOS</summary>

```shell
# to install the latest stable version:
brew install neovim
# or, to install the nightly version:
brew install --HEAD neovim

git clone --depth=1 https://github.com/clementjumel/kickstart.nvim ~/.config/nvim
# optionally, to install plugins & external tools from the command line:
nvim "+Lazy install" +qall
```

</details>
<details>
<summary>Ubuntu</summary>

```shell
apt install software-properties-common
add-apt-repository ppa:neovim-ppa/unstable
apt update
apt install neovim
git clone --depth=1 https://github.com/clementjumel/kickstart.nvim ~/.config/nvim
# optionally, to install plugins & external tools from the command line:
nvim "+Lazy install" +qall
```

</details>
