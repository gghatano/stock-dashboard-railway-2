# テンプレート完成チェックリスト

## ディレクトリ構造

### カスタムコマンド（Claude Code用）
- [x] `.claude/commands/pm.md`
- [x] `.claude/commands/arch.md`
- [x] `.claude/commands/eng.md`
- [x] `.claude/commands/rev.md`

### スキル定義
- [x] `.claude/skills/technical-advisor/SKILL.md`
- [x] `.claude/skills/project-management/SKILL.md`
- [x] `.claude/skills/architecture-design/SKILL.md`
- [x] `.claude/skills/implementation/SKILL.md`
- [x] `.claude/skills/code-review/SKILL.md`

### 設定ファイル
- [x] `.clinerules`
- [x] `.gitignore`
- [x] `CLAUDE.md`
- [x] `README.md`

### ドキュメント
- [x] `doc/仕様書.md`
- [x] `doc/開発方針.md`
- [x] `doc/worktree-workflow.md`
- [x] `doc/tasks/README.md`
- [x] `doc/diagrams/README.md`

### スクリプト
- [x] `scripts/worktree-manager.sh` (実行権限あり)

### テンプレート
- [x] `templates/feature-task.md`
- [x] `templates/bug-report.md`
- [x] `templates/review-checklist.md`

---

## 確認コマンド

### カスタムコマンド
```bash
ls .claude/commands/*.md
```
期待: 4つのコマンドファイル（pm.md, arch.md, eng.md, rev.md）

### スキルファイル
```bash
ls .claude/skills/*/SKILL.md
```
期待: 5つのSKILL.mdファイル

### スクリプト
```bash
ls -la scripts/
```
期待: worktree-manager.sh が実行権限付きで存在

### ドキュメント
```bash
ls doc/
```
期待: 仕様書.md, 開発方針.md, worktree-workflow.md, tasks/, diagrams/

---

## 動作確認

### Worktreeスクリプト
```bash
./scripts/worktree-manager.sh help
```
期待: ヘルプメッセージが表示される

### ディレクトリ構造
```bash
tree -L 2 .claude/
```
期待:
```
.claude/
├── commands/
│   ├── pm.md
│   ├── arch.md
│   ├── eng.md
│   └── rev.md
└── skills/
    ├── technical-advisor/
    ├── project-management/
    ├── architecture-design/
    ├── implementation/
    └── code-review/
```

---

## カスタムコマンドの動作確認

Claude Codeで以下のコマンドをテスト:

### /pm
```
/pm 現在のタスク状況を確認
```
期待: タスク一覧が表示され、次のアクションが提案される

### /arch
```
/arch サンプル機能の設計を作成して
```
期待: 標準フォーマットで設計書が出力される

### /eng
```
/eng サンプルファイルを作成して
```
期待: 実装が実行され、完了報告と次のステップが案内される

### /rev
```
/rev [対象パス] をレビューして
```
期待: チェックリストに基づくレビュー結果が出力される

---

## 完了

すべての項目が完了したら、このテンプレートは使用可能です！

次のステップ:
1. 新しいプロジェクトにコピー
2. README.mdの手順に従ってセットアップ
3. doc/仕様書.md と doc/開発方針.md を編集
4. 開発開始
