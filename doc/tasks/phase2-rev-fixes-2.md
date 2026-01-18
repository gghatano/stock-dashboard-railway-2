# 📋 タスク設計書: Phase 2 レビュー指摘対応 - 画面幅問題
━━━━━━━━━━━━━━━━━━━━━━━━

## 概要

「ブラウザの幅全体を使っていない」問題が未解決。原因を特定し修正する。

---

## 原因分析

**問題**: 画面が縦に長く、ブラウザ幅全体を使っていない

**根本原因**: `index.css` (Viteデフォルト) の `body` スタイル

```css
/* index.css:25-31 - 問題のコード */
body {
  margin: 0;
  display: flex;
  place-items: center;  /* ← これが中央寄せの原因 */
  min-width: 320px;
  min-height: 100vh;
}
```

`place-items: center` は `align-items: center` と `justify-items: center` の省略形で、コンテンツを画面中央に配置する。これによりアプリ全体が中央寄せされ、幅を使い切れていない。

---

## サブタスク分割

| # | サブタスク | 説明 | ファイル |
|---|-----------|------|---------|
| 1 | body スタイル修正 | `place-items: center` を削除 | `index.css` |
| 2 | 不要なダークモード設定削除 | Viteデフォルトの不要スタイル整理 | `index.css` |

---

## ファイル構成

```
frontend/src/
└── index.css  # 修正: body の place-items 削除、不要スタイル整理
```

---

## 実装方針

### index.css の修正

**変更前**:
```css
body {
  margin: 0;
  display: flex;
  place-items: center;  /* 問題 */
  min-width: 320px;
  min-height: 100vh;
}
```

**変更後**:
```css
body {
  margin: 0;
  min-width: 320px;
  min-height: 100vh;
}
```

### 追加で整理すべき点

`index.css` はViteのデフォルトテンプレートで、ダークモード対応などダッシュボードには不要なスタイルが含まれている。シンプルに整理する。

**整理後の index.css**:
```css
* {
  box-sizing: border-box;
}

body {
  margin: 0;
  min-width: 320px;
  min-height: 100vh;
  font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  line-height: 1.5;
  color: #1a1a1a;
  background-color: #f5f7fa;
}

button {
  font-family: inherit;
  cursor: pointer;
}
```

---

## 実装例（疑似コード）

なし（CSS修正のみ）

---

## 完了条件

- [ ] ブラウザ幅全体を使ったレイアウトになる
- [ ] カード2枚が横並びで適切に表示される
- [ ] モバイルでは縦並びになる
- [ ] `/rev` でレビュー完了

---

## 確認方法

1. フロントエンド起動: `cd frontend && npm run dev`
2. ブラウザで http://localhost:5173 を開く
3. ブラウザ幅を変えて確認:
   - デスクトップ: カード2枚が横並び、画面幅を広く使う
   - モバイル (768px以下): カード縦並び

━━━━━━━━━━━━━━━━━━━━━━━━
## 📋 次のステップ

1. `/eng doc/tasks/phase2-rev-fixes-2.md を実装して`
2. 動作確認（目視）
3. `/rev` でレビュー
4. コミット
