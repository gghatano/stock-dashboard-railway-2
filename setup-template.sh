#!/bin/bash

# ccsdd-template setup script
# テンプレートディレクトリに必要なファイルとディレクトリを作成

set -e

echo "🚀 Setting up ccsdd-template..."

# scriptsディレクトリ作成
mkdir -p scripts

# templatesディレクトリ作成
mkdir -p templates

# .gitignore作成
cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
.venv
*.egg-info/
dist/
build/

# Node
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnpm-debug.log*
dist/
build/

# IDE
.vscode/
.idea/
*.swp
*.swo
.DS_Store

# Worktree
worktrees/

# Environment
.env
.env.local
*.local

# Logs
logs/
*.log

# Test
.coverage
htmlcov/
.pytest_cache/
.tox/

# Database
*.db
*.sqlite
*.sqlite3

# OS
Thumbs.db
.Spotlight-V100
.Trashes
EOF

# scripts/worktree-setup.sh作成
cat > scripts/worktree-setup.sh << 'EOF'
#!/bin/bash

# Worktree作成スクリプト

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <feature-name>"
    echo "Example: $0 user-auth"
    exit 1
fi

FEATURE_NAME=$1
BRANCH_NAME="feature/${FEATURE_NAME}"
WORKTREE_PATH="worktrees/${FEATURE_NAME}"

# Worktreeディレクトリが存在しない場合作成
mkdir -p worktrees

# Worktree作成
echo "📁 Creating worktree: ${WORKTREE_PATH}"
echo "🌿 Branch: ${BRANCH_NAME}"

git worktree add "${WORKTREE_PATH}" -b "${BRANCH_NAME}"

echo "✅ Worktree created successfully!"
echo ""
echo "Next steps:"
echo "  cd ${WORKTREE_PATH}"
echo "  # Start development"
EOF

# scripts/worktree-cleanup.sh作成
cat > scripts/worktree-cleanup.sh << 'EOF'
#!/bin/bash

# Worktree削除スクリプト

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <feature-name>"
    echo "Example: $0 user-auth"
    exit 1
fi

FEATURE_NAME=$1
WORKTREE_PATH="worktrees/${FEATURE_NAME}"
BRANCH_NAME="feature/${FEATURE_NAME}"

# Worktreeが存在するか確認
if [ ! -d "${WORKTREE_PATH}" ]; then
    echo "❌ Worktree not found: ${WORKTREE_PATH}"
    exit 1
fi

# Worktree削除
echo "🗑️  Removing worktree: ${WORKTREE_PATH}"
git worktree remove "${WORKTREE_PATH}"

# ブランチ削除確認
read -p "Delete branch ${BRANCH_NAME}? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git branch -d "${BRANCH_NAME}" 2>/dev/null || git branch -D "${BRANCH_NAME}"
    echo "✅ Branch deleted: ${BRANCH_NAME}"
else
    echo "ℹ️  Branch kept: ${BRANCH_NAME}"
fi

echo "✅ Cleanup completed!"
EOF

# scripts/dev-workflow.sh作成
cat > scripts/dev-workflow.sh << 'EOF'
#!/bin/bash

# 開発ワークフロー支援スクリプト

set -e

echo "🔧 Development Workflow Helper"
echo ""
echo "Select an action:"
echo "  1) List all worktrees"
echo "  2) Create new worktree"
echo "  3) Cleanup worktree"
echo "  4) Show current status"
echo "  5) Exit"
echo ""
read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        echo ""
        echo "📋 Current worktrees:"
        git worktree list
        ;;
    2)
        echo ""
        read -p "Enter feature name: " feature_name
        ./scripts/worktree-setup.sh "$feature_name"
        ;;
    3)
        echo ""
        read -p "Enter feature name to cleanup: " feature_name
        ./scripts/worktree-cleanup.sh "$feature_name"
        ;;
    4)
        echo ""
        echo "📊 Current Status:"
        echo ""
        echo "Current branch:"
        git branch --show-current
        echo ""
        echo "Worktrees:"
        git worktree list
        echo ""
        echo "Recent commits:"
        git log --oneline -5
        ;;
    5)
        echo "👋 Bye!"
        exit 0
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac
EOF

# templates/feature-task.md作成
cat > templates/feature-task.md << 'EOF'
# 機能タスク: [機能名]

## 概要
この機能の簡単な説明

## 目的
なぜこの機能が必要なのか

## スコープ
### 含む
- 実装する内容1
- 実装する内容2

### 含まない
- 今回は実装しない内容1
- 今回は実装しない内容2

## 設計
### ファイル構成
```
backend/
  └── app/
      └── api/
          └── feature.py
frontend/
  └── src/
      └── components/
          └── Feature.jsx
```

### 実装方針
- 方針1
- 方針2

### データモデル
```python
class Feature:
    id: int
    name: str
    created_at: datetime
```

## タスクリスト
- [ ] バックエンドAPI実装
- [ ] フロントエンドUI実装
- [ ] ユニットテスト作成
- [ ] 統合テスト作成
- [ ] ドキュメント更新

## 完了条件
- [ ] すべてのテストが通る
- [ ] @revレビュー完了
- [ ] ドキュメントが更新されている
- [ ] 仕様書通りに動作する

## 注意事項
- 注意点1
- 注意点2

## 参考資料
- [関連ドキュメント](リンク)
EOF

# templates/bug-report.md作成
cat > templates/bug-report.md << 'EOF'
# バグレポート: [バグの簡単な説明]

## 概要
バグの概要を記載

## 発生環境
- OS: 
- ブラウザ: 
- バージョン: 

## 再現手順
1. 手順1
2. 手順2
3. 手順3

## 期待される動作
正しい動作の説明

## 実際の動作
実際に発生した動作の説明

## スクリーンショット・ログ
```
エラーログやスクリーンショットをここに
```

## 影響範囲
- 重要度: [高/中/低]
- 影響するユーザー: 
- 回避策の有無: 

## 原因調査
疑わしい原因や調査内容

## 修正方針
どのように修正するか

## タスクリスト
- [ ] 原因特定
- [ ] 修正実装
- [ ] テスト追加
- [ ] 動作確認
- [ ] レビュー

## 関連Issue・PR
- 関連Issue: #xxx
- 関連PR: #xxx
EOF

# templates/review-checklist.md作成
cat > templates/review-checklist.md << 'EOF'
# レビューチェックリスト

作成日: YYYY-MM-DD
レビュアー: 
対象PR/ブランチ: 

## 📋 コード品質
- [ ] 命名規則に従っているか（変数、関数、クラス名）
- [ ] コメントは適切か（複雑な処理に説明がある）
- [ ] 不要なコード（コメントアウト、デバッグコード）は削除されているか
- [ ] DRY原則に従っているか（重複コードがない）
- [ ] 関数は単一責任を持っているか
- [ ] マジックナンバーは定数化されているか

## ⚙️ 機能
- [ ] 仕様書通りに動作するか
- [ ] エッジケースを考慮しているか
- [ ] エラーハンドリングは適切か
- [ ] ユーザー入力の検証は適切か
- [ ] 正常系・異常系の両方をテストしているか

## 🧪 テスト
- [ ] ユニットテストは追加されているか
- [ ] テストは全て通るか
- [ ] テストカバレッジは十分か（目安: 80%以上）
- [ ] テストケース名は分かりやすいか
- [ ] モックは適切に使用されているか

## 🔒 セキュリティ
- [ ] 入力値の検証・サニタイズは適切か
- [ ] SQLインジェクション対策はされているか
- [ ] XSS対策はされているか
- [ ] 認証・認可は適切か
- [ ] 機密情報（パスワード、トークン）の扱いは適切か
- [ ] ログに機密情報が出力されていないか

## ⚡ パフォーマンス
- [ ] 不要な処理（ループ、API呼び出し）はないか
- [ ] N+1問題はないか
- [ ] 適切にキャッシュを使用しているか
- [ ] データベースクエリは最適化されているか
- [ ] メモリリークの可能性はないか

## 📚 ドキュメント
- [ ] READMEは更新されているか
- [ ] APIドキュメントは更新されているか
- [ ] CHANGELOGは更新されているか
- [ ] コードコメント（Docstring）は適切か
- [ ] 設定変更が必要な場合、手順が記載されているか

## 🎨 フロントエンド（該当する場合）
- [ ] UIは仕様通りか
- [ ] レスポンシブデザインは適切か
- [ ] アクセシビリティは考慮されているか
- [ ] ローディング状態の表示は適切か
- [ ] エラーメッセージは分かりやすいか

## 🔄 Git
- [ ] コミットメッセージは適切か
- [ ] 論理的な単位でコミットされているか
- [ ] ブランチ名は規約に従っているか
- [ ] マージコンフリクトは解決されているか

## 総合評価

### 🔴 重要度：高（修正必須）
- 

### 🟡 重要度：中（修正推奨）
- 

### 🟢 重要度：低（改善提案）
- 

### 👍 良かった点
- 

## 結論
- [ ] 承認
- [ ] 条件付き承認（軽微な修正後にマージ可）
- [ ] 再レビュー必要

## コメント

EOF

# スクリプトに実行権限付与
chmod +x scripts/*.sh

echo ""
echo "✅ Setup completed!"
echo ""
echo "Created files:"
echo "  📄 .gitignore"
echo "  📁 scripts/"
echo "    ├── worktree-setup.sh"
echo "    ├── worktree-cleanup.sh"
echo "    └── dev-workflow.sh"
echo "  📁 templates/"
echo "    ├── feature-task.md"
echo "    ├── bug-report.md"
echo "    └── review-checklist.md"
echo ""
echo "Next steps:"
echo "  1. Review and customize the generated files"
echo "  2. Test worktree scripts: ./scripts/worktree-setup.sh test-feature"
echo "  3. Start your development workflow!"
