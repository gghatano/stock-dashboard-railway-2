# API設計パターン

## RESTful エンドポイント

```
GET    /api/v1/resources          # リスト取得
POST   /api/v1/resources          # 新規作成
GET    /api/v1/resources/:id      # 詳細取得
PUT    /api/v1/resources/:id      # 更新
DELETE /api/v1/resources/:id      # 削除
```

## レスポンス形式

### 成功時
```json
{
  "data": { ... },
  "meta": {
    "total": 100,
    "page": 1,
    "per_page": 20
  }
}
```

### エラー時
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "入力内容に問題があります",
    "details": [
      { "field": "email", "message": "メールアドレスの形式が不正です" }
    ]
  }
}
```

## HTTPステータスコード

| コード | 用途 |
|--------|------|
| 200 | 成功（GET, PUT） |
| 201 | 作成成功（POST） |
| 204 | 成功・コンテンツなし（DELETE） |
| 400 | リクエスト不正 |
| 401 | 認証エラー |
| 403 | 権限エラー |
| 404 | リソース未発見 |
| 422 | バリデーションエラー |
| 500 | サーバーエラー |

## ページネーション

```
GET /api/v1/users?page=2&per_page=20
GET /api/v1/users?cursor=abc123&limit=20
```

## フィルタリング・ソート

```
GET /api/v1/users?status=active&role=admin
GET /api/v1/users?sort=created_at&order=desc
```
