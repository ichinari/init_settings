# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=/opt/homebrew/bin:$PATH
# export PATH=$PATH:`npm bin -g`  # nvmと競合するためコメントアウト
export PATH=$PATH:/Users/ky/flutter/bin
eval "$(/opt/homebrew/bin/brew shellenv)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# WezTerm: 現在のディレクトリを通知（新しいタブ/ペインで引き継ぎ）
autoload -Uz add-zsh-hook
_osc7_cwd() {
  printf '\033]7;file://%s%s\033\\' "$HOST" "$PWD"
}
add-zsh-hook chpwd _osc7_cwd
_osc7_cwd  # 初回実行

# claudeCodeとcodexのログ解析関連のショートカット
# 統合エントリポイント: ccu
# - ccu codex [daily|monthly|session|...] [opts...]
# - ccu claude
# 既定は daily（引数が無い場合）
ccu() {
  local subcmd="$1"
  shift || true

  case "$subcmd" in
    codex)
      if [[ -z "$1" ]]; then
        npx @ccusage/codex@latest daily
      else
        npx @ccusage/codex@latest "$@"
      fi
      ;;
    claude)
      npx ccusage@latest
      ;;
    help|-h|--help|"")
      echo "Usage:"
      echo "  ccu codex [daily|monthly|session|...] [opts...]  # ccusage/codex"
      echo "  ccu claude                                       # ccusage"
      echo ""
      echo "Examples:"
      echo "  ccu codex daily --json"
      echo "  ccu claude"
      return 0
      ;;
    *)
      echo "Unknown subcommand: $subcmd"
      echo "Try: ccu help"
      return 1
      ;;
  esac
}

# Powerlevel10k theme
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
