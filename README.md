# Stock Dashboard

S&P500とFANG+インデックスの株価情報を円建て/ドル建てで表示するダッシュボード。

## 概要

- **データソース**: Yahoo Finance (yfinance)
- **監視対象**: S&P500 (^GSPC), FANG+ (^NYFANG), USD/JPY為替レート
- **機能**: 現在価格、前日比、14日間チャート、通貨切替（円/USD）

## クイックスタート

### ローカル開発

```bash
# バックエンド起動
cd backend
uv run uvicorn main:app --reload --port 8000

# フロントエンド起動（別ターミナル）
cd frontend
npm install
npm run dev
```

- フロントエンド: http://localhost:5173
- バックエンドAPI: http://localhost:8000
- ヘルスチェック: http://localhost:8000/health
- インデックスAPI: http://localhost:8000/api/indices

### 本番ビルド

```bash
cd frontend && npm run build
cd ../backend && uv run uvicorn main:app --host 0.0.0.0 --port 8000
```

## Railway デプロイ

### デプロイ方式

FastAPIが`frontend/dist`を静的配信する方式を採用。

- `/api/*` → FastAPI APIエンドポイント
- `/health` → ヘルスチェック
- `/` および未知パス → `index.html` (SPA)

### Railway設定

1. Railwayプロジェクト作成
2. GitHubリポジトリを接続
3. 自動デプロイが有効化（nixpacks.tomlを自動検出）

**ビルド設定** (`nixpacks.toml`):
- setup: Node.js 20, Python 3.12
- build: `cd frontend && npm ci && npm run build`
- start: `uvicorn backend.main:app --host 0.0.0.0 --port $PORT`

### 環境変数（任意）

| 変数 | 説明 | デフォルト |
|------|------|-----------|
| PORT | サーバーポート | 8000 |

## API仕様

### GET /health

```json
{"status": "healthy", "timestamp": "2026-01-18T10:00:00"}
```

### GET /api/indices

```json
{
  "indices": [
    {
      "ticker": "^GSPC",
      "name": "S&P 500",
      "current_price": 5892.45,
      "previous_close": 5850.23,
      "change": 42.22,
      "change_percent": 0.72,
      "chart_data": [{"date": "2026-01-04", "close": 5800.12}, ...],
      "last_update": "2026-01-18T10:00:00"
    }
  ],
  "exchange_rate": {"rate": 157.32, "last_update": "..."},
  "timestamp": "2026-01-18T10:00:00",
  "isFallback": false
}
```

**注意**: yfinanceでデータ取得に失敗した場合、`isFallback: true`でダミーデータを返却。

---

## 開発環境

### 必須ツール
- **VSCode**: 最新版推奨
- **Git**: 2.15以上（worktree機能のため）
- **Claude Code**: VSCode拡張機能
- その他プロジェクト固有のツール（Python、Node.jsなど）

### VSCode推奨拡張機能
- Claude Code
- GitLens
- その他プロジェクト固有の拡張機能

---


### 2. プロジェクト仕様の準備
以下のドキュメントを編集してプロジェクトの詳細を記載：
- `doc/仕様書.md` - システムの詳細仕様
- `doc/開発方針.md` - フェーズ別タスク計画

### 3. VSCodeでプロジェクトを開く
```bash
code .
```

---

## 開発ワークフロー

本プロジェクトは **VSCode + Git Worktree + Claude Code** を組み合わせた開発フローを採用しています。

### 基本的な流れ
```
1. タスク計画 (/pm)
   ↓
2. 詳細設計 (/arch)
   ↓
3. Worktree作成
   ↓
4. 実装 (/eng)
   ↓
5. レビュー (/rev)
   ↓
6. マージ & クリーンアップ
```

---

### ステップ1: タスク計画（/pm）

プロジェクトマネージャーエージェントに相談して、次に取り組むべきタスクを明確にします。
```
/pm 次のフェーズのタスクを確認して
```

<details>
<summary>📋 PMからの応答例を見る</summary>
```
📊 現在の状況
フェーズ1: 基本機能実装 (進捗: 60%)
- 完了: 3/5 タスク
- 進行中: 1 タスク

✅ 次のアクション
Task-1.4: ユーザー認証機能

📋 完了条件
- ログイン/ログアウト機能
- セッション管理
- 認証ミドルウェア

⚠️ 注意事項
既存のユーザーテーブルとの互換性を保つこと
```

</details>

---

### ステップ2: 詳細設計（/arch）

アーキテクトエージェントに設計を依頼します。
```
/arch Task-1.4「ユーザー認証機能」の詳細設計を作成して
```

<details>
<summary>📋 Architectからの応答例を見る</summary>
```
📋 タスク分割
1. バックエンド認証API実装
2. フロントエンド認証UI実装
3. セッション管理機能

📁 ファイル構成
backend/
  └── app/
      ├── api/
      │   └── auth.py
      └── services/
          └── auth_service.py

💡 実装方針
- JWT認証を使用
- HTTPOnly Cookieでトークン管理

✅ 完了条件
- ログイン/ログアウトが正常に動作
- 認証エラー時の適切なハンドリング
```

</details>

設計内容は必要に応じて `doc/tasks/` に保存します。

---

### ステップ3: Worktree作成

新しい機能用のWorktreeを作成します。
```bash
# Worktree作成
./scripts/worktree-manager.sh create user-auth

# Worktreeディレクトリに移動
cd worktrees/user-auth

# VSCodeで開く
code .
```

**重要:** 各Worktreeは独立したVSCodeウィンドウで開くことを推奨します。

---

### ステップ4: 実装（/eng）

エンジニアエージェントで実装を依頼します。
```
/eng Task-1.4「ユーザー認証機能」を実装して

以下の設計に従ってください：
[@archで作成した設計内容]
```

実装中は：
- Claude Codeが自動的にファイルを作成・編集
- 不明点があればその都度質問
- 段階的に動作確認

実装完了後、コミットします。
```bash
git add .
git commit -m "feat: ユーザー認証機能を実装

- JWT認証API実装
- ログイン/ログアウトUI実装
- セッション管理機能追加"
```

---

### ステップ5: レビュー（/rev）

プロジェクトルートに戻り、レビュアーエージェントにレビューを依頼します。
```bash
# プロジェクトルートへ
cd ../..
```
```
/rev worktrees/user-auth の実装をレビューして
```

<details>
<summary>📋 Reviewerからの応答例を見る</summary>
```
🎯 総合評価
実装は概ね良好です。軽微な修正を推奨します。

🔴 重要度：高（修正必須）
なし

🟡 重要度：中（修正推奨）
1. auth.py:45 - パスワードの最小文字数チェックを追加
2. Login.jsx:30 - エラーメッセージの表示を改善

🟢 重要度：低（改善提案）
1. ログ出力を追加すると運用時に便利

👍 良かった点
- JWT実装が適切
- エラーハンドリングが丁寧
```

</details>

レビュー指摘事項があれば、Worktreeに戻って修正します。
```bash
cd worktrees/user-auth
```
```
/eng 以下のレビュー指摘事項を修正して：

[レビュー内容]
```

---

### ステップ6: マージとクリーンアップ

レビューが完了したら、mainブランチにマージします。
```bash
# mainブランチに戻る
git checkout main

# マージ
git merge feature/user-auth

# テスト実行
[プロジェクト固有のテストコマンド]

# リモートにプッシュ
git push origin main

# Worktreeクリーンアップ
./scripts/worktree-manager.sh cleanup user-auth
```

---

## ナレッジ管理

プロジェクトで得た知見を適切に記録・管理します。

### クイックスタート

```bash
# プロジェクト固有の技術知見を追加
/knowledge project 認証トークンの有効期限はアクセス1時間、リフレッシュ7日

# 実装関連の知見を追加
/knowledge skill:eng Pythonのasync関数では必ずawaitを使用する

# 全体ルールを追加
/knowledge rule コミット前に必ずlintを実行する
```

### 知見の配置先（概要）

| 知見の種類 | 配置先 |
|-----------|--------|
| プロジェクト固有の技術 | `doc/project_knowledge.md` |
| 役割固有の知識 | `.claude/skills/*/*.md` |
| 全体ルール | `CLAUDE.md` |

**詳細**: [KNOWLEDGE_GUIDE.md](./KNOWLEDGE_GUIDE.md) を参照

### 定期レビュー（月1回）

1. `doc/project_knowledge.md` の内容を確認・整理
2. SKILL.mdが肥大化していないか確認（目安: 80行以下）

---

## 並行開発

複数の機能を同時に開発する場合：

### 1. 複数のWorktreeを作成
```bash
./scripts/worktree-manager.sh create feature-a
./scripts/worktree-manager.sh create feature-b
```

### 2. 各Worktreeで別々のVSCodeウィンドウを開く
```bash
code worktrees/feature-a
code worktrees/feature-b
```

### 3. それぞれ独立して開発
- ウィンドウ1: Feature A を実装
- ウィンドウ2: Feature B を実装

### 4. 完了した順にレビュー・マージ
```bash
# Feature Aが完了
/rev worktrees/feature-a をレビュー
git merge feature/feature-a
./scripts/worktree-manager.sh cleanup feature-a
```

---

## 開発支援ツール

### Worktree管理
```bash
# Worktree一覧
./scripts/worktree-manager.sh list

# Worktreeの状態確認
./scripts/worktree-manager.sh status feature-name

# mainブランチと同期
./scripts/worktree-manager.sh sync feature-name

# Worktree削除
./scripts/worktree-manager.sh cleanup feature-name

# 不要なWorktreeをクリーンアップ
./scripts/worktree-manager.sh prune
```

---

## トラブルシューティング

### Worktreeが削除できない
```bash
# 強制削除
git worktree remove --force worktrees/feature-name
```

### ブランチが残っている
```bash
# ブランチ削除
git branch -d feature/feature-name

# マージされていないブランチを強制削除
git branch -D feature/feature-name
```

### VSCodeでWorktreeが認識されない
1. VSCodeを再起動
2. Worktreeディレクトリで直接 `code .` を実行

### Claude Codeが以前のコンテキストを参照してしまう
1. 各Worktreeは独立したVSCodeウィンドウで開く
2. Claude Codeのチャット履歴をクリア
3. 新しいチャットセッションを開始

### コンフリクト解決
```bash
# コンフリクトファイルを確認
git status

# 技術アドバイザーに相談
「以下のコンフリクトを解決する方法を教えて：
[コンフリクト内容]」

# または /eng で解決
/eng 以下のコンフリクトを解決して：
[コンフリクト内容]
```

---

## ベストプラクティス

### ✅ すべきこと
- 機能ごとに独立したWorktreeを作成
- 各Worktreeは別々のVSCodeウィンドウで開く
- `/pm` → `/arch` → `/eng` → `/rev` の順で進める
- 小さな単位で頻繁にコミット
- レビュー指摘は必ず修正してからマージ
- 定期的に `worktree-manager.sh prune` で不要なWorktreeを削除

### ❌ 避けるべきこと
- 長期間放置したWorktreeを残す
- 複数Worktreeで同じファイルを同時編集
- レビューなしでマージ
- コミットメッセージを省略
- テストをスキップ
- ドキュメント更新を忘れる

---

## ディレクトリ構造
```
project/
├── .claude/
│   └── skills/              # Claude Code スキル
│       ├── technical-advisor/
│       ├── project-management/
│       ├── architecture-design/
│       ├── implementation/
│       └── code-review/
├── .clinerules              # 共通ルール
├── .gitignore
├── README.md
├── doc/                     # ドキュメント
│   ├── 仕様書.md
│   ├── 開発方針.md
│   ├── architecture.md
│   ├── worktree-workflow.md
│   ├── tasks/               # タスク詳細
│   └── diagrams/            # 図表
├── scripts/                 # 開発支援スクリプト
│   └── worktree-manager.sh
├── templates/               # テンプレート
│   ├── feature-task.md
│   ├── bug-report.md
│   └── review-checklist.md
└── worktrees/               # 並行開発用 (gitignore)
    ├── feature-a/
    └── feature-b/
```

---

## 📚 関連ドキュメント

### 開発プロセス
- [開発方針とタスク管理](./doc/開発方針.md)
- [Worktreeワークフロー](./doc/worktree-workflow.md)

### ナレッジ管理
- [知見配置ガイド](./KNOWLEDGE_GUIDE.md) - 何をどこに書くか
- [プロジェクト知見](./doc/project_knowledge.md) - プロジェクト固有の技術知見

### 仕様・設計
- [システム仕様書](./doc/仕様書.md)
- [アーキテクチャ](./doc/architecture.md)

### エージェント設定
- [技術アドバイザー](./.claude/skills/technical-advisor/SKILL.md)
- [プロジェクトマネージャー](./.claude/skills/project-management/SKILL.md)
- [アーキテクト](./.claude/skills/architecture-design/SKILL.md)
- [エンジニア](./.claude/skills/implementation/SKILL.md)
- [レビュアー](./.claude/skills/code-review/SKILL.md)

---

## ライセンス
[ライセンス情報を記載]

## コントリビューション
[コントリビューションガイドを記載]
