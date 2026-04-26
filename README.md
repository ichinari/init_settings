# 概要

macOS 開発環境を管理するリポジトリ。  
新しい Mac でワンコマンドで同じ環境を再現できます。

## 含まれる設定

| ツール | 説明 |
|--------|------|
| **Neovim** | NvChad ベース（LSP: vtsls / cssls / html / tailwindcss、Telescope、Trouble 等） |
| **Zsh + Powerlevel10k** | シェル環境（ccu） |
| **Git** | グローバル設定 |
| **Homebrew** | パッケージ一覧（Brewfile） |

## ディレクトリ構成

```
init_settings/
├── install.sh           # シンボリックリンク一括作成
├── README.md            # 本ファイル
├── docs/                # 手順・確認方法
│   └── 設定一覧と手順.md
├── nvim/                # ~/.config/nvim にリンク
│   ├── init.lua
│   ├── lua/
│   │   ├── configs/     # lspconfig, telescope, trouble, diagnostic 等
│   │   ├── custom/      # plugins, chadrc, ascii_art 等
│   │   ├── mappings.lua
│   │   ├── options.lua
│   │   ├── autocmds.lua
│   │   ├── plugins/     # プラグイン定義
│   │   └── user/        # terminal_keys 等
│   └── pack/
├── zsh/
│   ├── .zshrc           # ccu
│   └── .zprofile
├── git/
│   ├── .gitconfig
│   └── .gitignore_global
├── .p10k.zsh
└── Brewfile
```

## セットアップ

### 1. Homebrew インストール

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. リポジトリをクローン

```bash
git clone <このリポジトリのURL> ~/development/init_settings
```

### 3. インストールスクリプト実行

```bash
cd ~/development/init_settings && ./install.sh
```

これで以下がシンボリックリンクで配置されます。

- `nvim` → `~/.config/nvim`
- `zsh/.zshrc` → `~/.zshrc`
- `zsh/.zprofile` → `~/.zprofile`
- `git/.gitconfig` → `~/.gitconfig`
- `git/.gitignore_global` → `~/.gitignore_global`
- `.p10k.zsh` → `~/.p10k.zsh`

### 4. 手動設定

```bash
source ~/.zshrc

# Git メールアドレス
git config --global user.email "your-email@example.com"

# Node.js（nvm）
nvm install --lts
```

### 5. Neovim の LSP（Mason）

nvim 起動後、以下で必要な LSP を入れる。

```vim
:Mason
```

- **vtsls**（TypeScript/JavaScript）: 必須（TS 開発時）
- **css_lsp** または **vscode-css-language-server**（CSS）
- **html**, **tailwindcss** は必要に応じて

詳細な手順・確認方法は [docs/設定一覧と手順.md](docs/設定一覧と手順.md) を参照。

## 注意

個人使用想定。メールアドレス等の個人情報は含めていません。
