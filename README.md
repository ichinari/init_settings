## 概要
macOS開発環境を管理するdotfilesリポジトリ。  
新しいMacでワンコマンドで同じ環境を再現できます。

## 含まれる設定
• WezTerm - GPU加速ターミナル  
• Neovim - NvChadベースのエディタ  
• Zsh + Powerlevel10k - シェル環境  
• Git - グローバル設定  
• Homebrew - パッケージ一覧 


## セットアップ
実行コマンド  
**※個人使用想定。メールアドレス等の個人情報は含まれていません。**

1. ディレクトリ作成
```
mkdir ~/development/init_settings_for_new_pc
```
2. クーロン
```
git clone https://github.com/zuya/init_settings_for_new_pc.git ~/development/init_settings_for_new_pc
```
3. 設定適応
```
cd ~/development/init_settings_for_new_pc/dotfiles && ./install.sh
```
