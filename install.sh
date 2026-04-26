#!/bin/bash

# dotfiles install script
# このスクリプトは各設定ファイルのシンボリックリンクを作成します

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🚀 dotfiles インストールを開始します..."
echo "📁 dotfiles directory: $DOTFILES_DIR"
echo ""

# バックアップディレクトリ
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# バックアップ関数
backup_if_exists() {
    local target="$1"
    if [ -e "$target" ] || [ -L "$target" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "  📦 バックアップ: $target → $BACKUP_DIR/"
        mv "$target" "$BACKUP_DIR/"
    fi
}

# シンボリックリンク作成関数
create_symlink() {
    local src="$1"
    local dest="$2"
    
    if [ ! -e "$src" ]; then
        echo "  ⚠️  ソースが見つかりません: $src"
        return
    fi
    
    backup_if_exists "$dest"
    
    # 親ディレクトリを作成
    mkdir -p "$(dirname "$dest")"
    
    ln -sf "$src" "$dest"
    echo "  ✅ $dest → $src"
}

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 Neovim"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 Zsh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 Git"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
# 空のコミットテンプレートファイルを作成
touch "$HOME/.stCommitMsg"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 Powerlevel10k"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
create_symlink "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🍺 Homebrew"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if command -v brew &> /dev/null; then
    echo "  📦 Brewfileからパッケージをインストール中..."
    brew bundle --file="$DOTFILES_DIR/Brewfile"
else
    echo "  ⚠️  Homebrewがインストールされていません"
    echo "  以下のコマンドでインストールしてください:"
    echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 追加の設定"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# nvm のインストール確認
if [ ! -d "$HOME/.nvm" ]; then
    echo "  📦 nvmをインストール中..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
else
    echo "  ✅ nvmは既にインストール済み"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚠️  手動で設定が必要な項目"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Gitのメールアドレスを設定:"
echo "   git config --global user.email \"your-email@example.com\""
echo ""
echo "2. Node.jsをインストール（nvmを使用）:"
echo "   source ~/.zshrc"
echo "   nvm install --lts"
echo ""
echo "3. Neovimプラグインのインストール:"
echo "   nvim を起動すると自動的にインストールされます"
echo ""

if [ -d "$BACKUP_DIR" ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📦 バックアップ"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "既存ファイルは以下にバックアップされました:"
    echo "  $BACKUP_DIR"
    echo ""
fi

echo "✨ インストール完了！"
echo "新しいターミナルを開くか、以下を実行してください:"
echo "  source ~/.zshrc"
