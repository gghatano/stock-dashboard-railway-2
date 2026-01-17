# stock-dashboard-railway-2

## 概要

このプロジェクトの説明をここに記述してください。

## セットアップ

```bash
# リポジトリのクローン
git clone <repository-url>
cd stock-dashboard-railway-2

# 依存関係のインストール（必要に応じて）
# npm install または pip install -r requirements.txt など
```

## 開発フロー

### ブランチ戦略

- `main`: 本番環境用の安定版ブランチ（直接コミット禁止）
- `develop`: 開発用の統合ブランチ
- `feature/*`: 機能開発用ブランチ
- `bugfix/*`: バグ修正用ブランチ
- `hotfix/*`: 緊急修正用ブランチ

### 開発手順

1. feature ブランチを作成
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. 開発・コミット
   ```bash
   git add .
   git commit -m "機能の説明"
   ```

3. プッシュ
   ```bash
   git push origin feature/your-feature-name
   ```

4. プルリクエストを作成

## ライセンス

[ライセンス情報を記載]
