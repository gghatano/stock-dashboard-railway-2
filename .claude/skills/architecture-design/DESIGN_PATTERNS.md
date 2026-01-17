# 設計パターン

## サービス層パターン

```python
class FeatureService:
    """ビジネスロジックを担当"""

    def __init__(self, repository: FeatureRepository):
        self.repository = repository

    def create(self, data: CreateRequest) -> Feature:
        # 1. バリデーション
        # 2. ビジネスルール適用
        # 3. 永続化
        pass
```

## リポジトリパターン

```python
class FeatureRepository:
    """データアクセスを担当"""

    def __init__(self, db: Database):
        self.db = db

    def find_by_id(self, id: int) -> Optional[Feature]:
        pass

    def create(self, data: dict) -> Feature:
        pass
```

## Reactコンポーネント構成

```
components/Feature/
├── index.tsx           # エントリーポイント
├── Feature.tsx         # メインコンポーネント
├── FeatureList.tsx     # リスト表示
├── FeatureItem.tsx     # アイテム表示
├── FeatureForm.tsx     # フォーム
├── hooks/
│   └── useFeature.ts   # カスタムフック
└── Feature.test.tsx    # テスト
```

## ファイル命名規則

| 言語 | パターン | 例 |
|------|---------|-----|
| Python | snake_case | `user_service.py` |
| JS/TS | camelCase | `userService.ts` |
| React | PascalCase | `UserProfile.tsx` |

## ディレクトリ構成原則

- 機能ごとにグループ化
- 共通機能は `common/` または `shared/`
- テストは実装の隣に配置
