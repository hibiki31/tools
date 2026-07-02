#!/bin/bash
#
# cleanup-personal-data.sh
# 共用サーバ退出時に個人情報を一括削除するスクリプト
#
# 使い方:
#   bash ~/cleanup-personal-data.sh
#
set -u

echo "=============================================="
echo " 個人情報クリーンアップスクリプト"
echo "=============================================="
echo "以下を削除します:"
echo "  - シェル/エディタ履歴 (.bash_history, .viminfo, .vim 等)"
echo "  - VSCode Server 全体 (.vscode-server: 認証トークン・編集履歴・設定含む)"
echo "  - AIツール (Cline: APIキー含む / Copilot)"
echo "  - 各種キャッシュ・設定 (.cache/Microsoft, .docker, .dotnet, .config/htop 等)"
echo "  - .wget-hsts (アクセス先ホスト情報)"

remove() {
  for target in "$@"; do
    if [ -e "$target" ] || [ -L "$target" ]; then
      rm -rf -- "$target" && echo "  [削除] $target" || echo "  [失敗] $target"
    fi
  done
}

echo ""
echo "--- シェル・エディタ履歴 ---"
remove "$HOME/.bash_history" \
       "$HOME/.viminfo" \
       "$HOME/.vim" \
       "$HOME/.lesshst" \
       "$HOME/.python_history" \
       "$HOME/.node_repl_history" \
       "$HOME/.sqlite_history" \
       "$HOME/.wget-hsts"

echo ""
echo "--- VSCode Server (認証情報・編集履歴・拡張機能) ---"
remove "$HOME/.vscode-server" \
       "$HOME/.vscode-remote-containers"

echo ""
echo "--- AIツール (Cline: APIキー含む / Copilot) ---"
remove "$HOME/.cline" \
       "$HOME/Cline" \
       "$HOME/.copilot"

echo ""
echo "--- キャッシュ・ツール設定 ---"
remove "$HOME/.docker" \
       "$HOME/.dotnet" \
       "$HOME/.config/htop" \
       "$HOME/.local/state" \
       "$HOME/.cache/Microsoft" \
       "$HOME/.gitconfig" \
       "$HOME/.git-credentials" \
       "$HOME/.netrc" \
       "$HOME/.sudo_as_admin_successful"

echo ""
echo "--- スクリプト自身を削除 ---"
rm -f -- "$0" && echo "  [削除] $0"

echo ""
echo "=============================================="
echo " 完了しました。"
echo ""
echo " ★重要: 現在のシェルのメモリ上に履歴が残っています。"
echo "   以下のコマンドでログアウトしてください:"
echo ""
echo "   history -c && kill -9 \$\$"
echo ""
echo " (通常の exit だと .bash_history が再作成されます)"
echo "=============================================="
