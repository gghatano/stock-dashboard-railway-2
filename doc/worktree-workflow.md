# Git Worktree開発ワークフロー

## Worktreeとは
複数のブランチを同時にチェックアウトして並行開発できるGitの機能

## ディレクトリ構造
\`\`\`
project/
├── .git/
├── worktrees/
│   ├── feature-a/  # 機能A開発用
│   ├── feature-b/  # 機能B開発用
│   └── review/     # レビュー用
└── [mainブランチの内容]
\`\`\`

## 基本コマンド

### Worktree作成
\`\`\`bash
# 新規ブランチで作成
git worktree add worktrees/feature-name -b feature/feature-name

# または、スクリプト使用
./scripts/worktree-setup.sh feature-name
\`\`\`

### Worktree一覧
\`\`\`bash
git worktree list
\`\`\`

### Worktree削除
\`\`\`bash
git worktree remove worktrees/feature-name

# または、スクリプト使用
./scripts/worktree-cleanup.sh feature-name
\`\`\`

## 開発フロー

### 1. タスク開始
\`\`\`bash
# @pmでタスク確認
@pm 次のタスクは？

# Worktree作成
./scripts/worktree-setup.sh user-auth
cd worktrees/user-auth
\`\`\`

### 2. 実装
\`\`\`bash
# Claude Codeで実装
# 必要に応じて@archで設計確認
\`\`\`

### 3. コミット
\`\`\`bash
git add .
git commit -m "feat: ユーザー認証機能を実装"
\`\`\`

### 4. レビュー準備
\`\`\`bash
# メインディレクトリに戻る
cd ../..

# @revでレビュー
@rev worktrees/user-auth の変更をレビューして
\`\`\`

### 5. マージ
\`\`\`bash
git checkout main
git merge feature/user-auth
git push origin main

# Worktree削除
./scripts/worktree-cleanup.sh user-auth
\`\`\`

## ベストプラクティス

### ✅ すべきこと
- 機能ごとにWorktreeを分ける
- 定期的にmainからrebaseする
- 不要なWorktreeは削除する
- Worktree名とブランチ名を対応させる

### ❌ 避けるべきこと
- 長期間放置したWorktreeを残す
- 複数Worktreeで同じファイルを編集
- Worktree削除前にブランチをマージしない

## トラブルシューティング

### Worktreeが削除できない
\`\`\`bash
git worktree remove --force worktrees/feature-name
\`\`\`

### ブランチが残っている
\`\`\`bash
git branch -d feature/feature-name
# 強制削除の場合
git branch -D feature/feature-name
\`\`\`
