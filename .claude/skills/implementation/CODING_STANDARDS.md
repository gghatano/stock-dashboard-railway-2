# コーディング規約

## Python (Backend)

### 基本ルール
- PEP 8準拠
- 型ヒント必須
- Docstring: Google style
- インデント: スペース4つ
- 行の長さ: 最大88文字（Black形式）

### 命名規則
| 種類 | 形式 | 例 |
|------|------|-----|
| 関数・変数 | snake_case | `create_user` |
| クラス | PascalCase | `UserService` |
| 定数 | UPPER_SNAKE | `MAX_RETRY_COUNT` |

### Docstring例
```python
def create_user(name: str, email: str) -> User:
    """
    新しいユーザーを作成する。

    Args:
        name: ユーザー名
        email: メールアドレス

    Returns:
        作成されたUserオブジェクト

    Raises:
        ValidationError: バリデーションエラー時
    """
```

## JavaScript/TypeScript (Frontend)

### 基本ルール
- ESLint推奨設定
- 関数コンポーネントのみ
- インデント: スペース2つ
- セミコロン: プロジェクト設定に従う

### 命名規則
| 種類 | 形式 | 例 |
|------|------|-----|
| 関数・変数 | camelCase | `createUser` |
| コンポーネント | PascalCase | `UserProfile` |
| 定数 | UPPER_SNAKE | `MAX_RETRY_COUNT` |

### 1コンポーネント1ファイル原則

## SQL

```sql
-- キーワードは大文字
-- 適切なインデント
SELECT
    u.id,
    u.name,
    COUNT(p.id) AS post_count
FROM
    users u
    LEFT JOIN posts p ON u.id = p.user_id
WHERE
    u.active = true
GROUP BY
    u.id, u.name;
```

## ファイル配置

### Backend
```
backend/app/
├── api/          # APIエンドポイント
├── models/       # データモデル
├── services/     # ビジネスロジック
├── repositories/ # データアクセス層
└── utils/        # ユーティリティ
```

### Frontend
```
frontend/src/
├── components/   # UIコンポーネント
├── pages/        # ページ
├── services/     # API通信
├── hooks/        # カスタムフック
└── utils/        # ユーティリティ
```
