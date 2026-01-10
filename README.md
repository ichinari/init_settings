# 概要
macOS開発環境を管理するリポジトリ。  
新しいMacでワンコマンドで同じ環境を再現できます。

## 含まれる設定

| ツール | 説明 |
|--------|------|
| WezTerm | GPU加速ターミナル |
| Neovim | NvChadベースのエディタ |
| Zsh + Powerlevel10k | シェル環境 |
| Powerlevel10k | プロンプトテーマ設定 |
| Git | グローバル設定 |
| Homebrew | パッケージ一覧 |

## セットアップ

### 1. Homebrew インストール
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. リポジトリをクローン
```bash
git clone https://github.com/zuya/init_settings_for_new_pc.git ~/development/init_settings_for_new_pc
```

### 3. インストールスクリプト実行
```bash
cd ~/development/init_settings_for_new_pc && ./install.sh
```

### 4. 手動設定
```bash
# シェルを再読み込み
source ~/.zshrc

# Git メールアドレス設定
git config --global user.email "your-email@example.com"

# Node.js インストール
nvm install --lts
```

### 5. Neovim プラグイン
nvim を起動すると自動的にインストールされます。

## 注意
個人使用想定。メールアドレス等の個人情報は含まれていません。

## 最近の変更
- WezTerm 設定を更新
- Neovim 設定を更新
