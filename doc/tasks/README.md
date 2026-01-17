# タスク詳細ドキュメント

このディレクトリには、各タスクの詳細設計ドキュメントを保存します。

## ファイル命名規則
```
task-[フェーズ番号].[タスク番号]-[機能名].md
```

### 例
- `task-1.1-database-design.md`
- `task-1.2-user-auth.md`
- `task-2.1-dashboard-ui.md`

## ドキュメント作成方法

### 1. テンプレートを使用
```bash
cp ../templates/feature-task.md doc/tasks/task-X.Y-feature-name.md
```

### 2. `/arch` で自動生成
```
/arch タスクX.Y の詳細設計を作成して

作成後、以下に保存してください：
doc/tasks/task-X.Y-feature-name.md
```

### 3. `/eng` で保存
```
/eng templates/feature-task.md を元に doc/tasks/task-X.Y-feature-name.md を作成して

内容：
[設計内容]
```

## ドキュメント構成

各タスクドキュメントには以下を含めます：

- **概要**: タスクの目的と背景
- **スコープ**: 含む内容と含まない内容
- **設計**: ファイル構成と実装方針
- **タスクリスト**: 実装すべき項目
- **完了条件**: 何をもって完了とするか

## 関連ドキュメント

- [開発方針](../開発方針.md) - タスク一覧
- [テンプレート](../templates/feature-task.md) - タスクドキュメントテンプレート
