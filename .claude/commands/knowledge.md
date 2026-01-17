---
description: "知見の追加・管理"
---

# 知見管理

プロジェクトの知見を適切な場所に記録します。

## 使い方

```
/knowledge [種類] [内容]
```

### 種類

| 種類 | 配置先 | 説明 |
|------|--------|------|
| `project` | `doc/project_knowledge.md` | プロジェクト固有の技術知見 |
| `skill:eng` | `.claude/skills/implementation/` | 実装関連の知見 |
| `skill:rev` | `.claude/skills/code-review/` | レビュー関連の知見 |
| `skill:arch` | `.claude/skills/architecture-design/` | 設計関連の知見 |
| `skill:pm` | `.claude/skills/project-management/` | PM関連の知見 |
| `rule` | `CLAUDE.md` | 全体ルール |

## 実行フロー

1. **種類の確認**: 指定された種類から配置先を特定
2. **内容の整形**: 知見を適切なフォーマットに整形
3. **配置先の確認**: ユーザーに配置先と内容を確認
4. **追記**: 承認後、該当ファイルに追記

## 出力フォーマット

```
📝 知見の追加
━━━━━━━━━━━━━━━━━━━━━━━━

種類: [種類]
配置先: [ファイルパス]

追加内容:
---
[整形された内容]
---

この内容を追加しますか？ [Yes/No/Edit]
```

## 整形ルール

### project（プロジェクト知見）
```markdown
### [タイトル]
**内容**: [詳細]
**日付**: YYYY-MM-DD
```

### skill:*（役割知見）
- SKILL.mdが80行以下 → SKILL.mdに追記
- SKILL.mdが80行超 → 適切なサブファイルに追記

### rule（全体ルール）
- 既存セクションに該当あり → そのセクションに追記
- 該当なし → 新セクション作成を提案

## 配置判断に迷った場合

`KNOWLEDGE_GUIDE.md` のフローチャートを参照:

```
知見を追加したい
    │
    ├─ 全コマンド共通？ → rule
    ├─ 特定の役割に関連？ → skill:[役割名]
    ├─ プロジェクト固有の技術？ → project
    └─ 不明 → 質問して確認
```

## 例

### プロジェクト知見の追加
```
/knowledge project 認証トークンの有効期限はアクセス1時間、リフレッシュ7日
```

### 実装知見の追加
```
/knowledge skill:eng Pythonのasync関数では必ずawaitを使用する
```

### 全体ルールの追加
```
/knowledge rule コミット前に必ずlintを実行する
```
