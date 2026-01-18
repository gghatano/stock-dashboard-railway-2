# 📋 タスク設計書: Phase 2 レビュー指摘対応
━━━━━━━━━━━━━━━━━━━━━━━━

## 概要

Phase 2のレビューで指摘された4点の修正を行う。

| # | 指摘内容 | カテゴリ |
|---|---------|---------|
| 1 | プロキシエラー時のコンソール表示改善 | フロントエンド |
| 2 | 画面幅が狭い問題の修正 | フロントエンド |
| 3 | チャートにデータ点を表示 | フロントエンド |
| 4 | バックエンド起動コマンドを`uv run`に変更 | ドキュメント |

---

## サブタスク分割

| # | サブタスク | 説明 | ファイル |
|---|-----------|------|---------|
| 1 | プロキシエラー対応 | バックエンド未起動時のエラーハンドリング改善 | `useIndicesData.ts` |
| 2 | 画面幅修正 | ブラウザ幅全体を使用するようCSS修正 | `App.css`, `index.css` |
| 3 | チャート点表示 | データ点を表示する設定追加 | `PriceChart.tsx` |
| 4 | ドキュメント更新 | `uv run`コマンドに統一 | `README.md`, `CLAUDE.md` |

---

## ファイル構成

```
frontend/src/
├── hooks/
│   └── useIndicesData.ts  # 修正: エラーメッセージ改善
├── components/
│   └── PriceChart.tsx     # 修正: dot={true}に変更
├── App.css                # 修正: 幅制限解除
└── index.css              # 確認: 基本スタイル

doc/
└── README.md              # 修正: uv run コマンドに変更

CLAUDE.md                  # 修正: uv run コマンドに変更
```

---

## 実装方針

### 1. プロキシエラー対応

**問題**: バックエンド未起動時に `ECONNREFUSED` エラーがコンソールに表示される

**対応方針**:
- エラーメッセージをユーザーフレンドリーに変更
- 接続エラー時は「バックエンドに接続できません」と表示
- フォールバックは既存通り動作（変更不要）

```typescript
// useIndicesData.ts
catch (err) {
  const message = err instanceof Error
    ? (err.message.includes('fetch') ? 'バックエンドに接続できません' : err.message)
    : 'Unknown error';
  setError(message);
  // フォールバック継続
}
```

### 2. 画面幅修正

**問題**: ブラウザ幅全体を使っていない

**原因調査**:
- `App.css` の `.main` に `max-width: 1200px` が設定されている
- これにより中央寄せで幅が制限される

**対応方針**:
- `max-width` を削除または大きくする
- または、カードコンテナの幅を調整

```css
/* App.css */
.main {
  /* max-width: 1200px; を削除またはより大きな値に */
  max-width: 1600px; /* または 100% */
  padding: 24px 48px; /* 左右のパディングを追加 */
}
```

### 3. チャート点表示

**問題**: チャートにデータ点が表示されていない

**対応方針**:
- `<Line>` コンポーネントの `dot` プロパティを変更

```tsx
// PriceChart.tsx
<Line
  type="monotone"
  dataKey="close"
  stroke="#6366f1"
  strokeWidth={2}
  dot={{ r: 3, fill: '#6366f1' }}  // ← 変更: false → オブジェクト指定
  activeDot={{ r: 5, fill: '#6366f1' }}
/>
```

### 4. ドキュメント更新

**対応方針**:
- `source .venv/bin/activate && uvicorn` を `uv run uvicorn` に変更
- README.md と CLAUDE.md を更新

```bash
# 変更前
cd backend
source .venv/bin/activate
uvicorn main:app --reload --port 8000

# 変更後
cd backend
uv run uvicorn main:app --reload --port 8000
```

---

## 実装例（疑似コード）

### PriceChart.tsx の変更箇所

```tsx
<Line
  type="monotone"
  dataKey="close"
  stroke="#6366f1"
  strokeWidth={2}
  dot={{ r: 3, fill: '#6366f1' }}        // 点を表示
  activeDot={{ r: 5, fill: '#6366f1' }}  // ホバー時の点
/>
```

### App.css の変更箇所

```css
.main {
  flex: 1;
  padding: 24px 48px;  /* 左右パディング追加 */
  max-width: 1600px;   /* より広く */
  margin: 0 auto;
  width: 100%;
  box-sizing: border-box;
}

.cards-container {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 24px;
  max-width: 1200px;  /* カード部分は適度な幅に */
  margin: 0 auto;
}
```

---

## 完了条件

- [ ] バックエンド未起動時にユーザーフレンドリーなエラー表示
- [ ] ブラウザ幅を広く使ったレイアウト
- [ ] チャートにデータ点が表示される
- [ ] README.md / CLAUDE.md で `uv run` コマンドに統一
- [ ] `/rev` でレビュー完了

---

## 注意事項

1. **画面幅の調整はバランスが重要**
   - 幅を広げすぎるとカードが横に広がりすぎる
   - カード自体は適度な幅を維持

2. **チャートの点サイズ**
   - データ点が多いため、小さめの点（r: 3程度）を推奨
   - 大きすぎると点が重なって見づらくなる

━━━━━━━━━━━━━━━━━━━━━━━━
## 📋 次のステップ

1. `/eng doc/tasks/phase2-rev-fixes.md を実装して`
2. 動作確認（目視）
3. `/rev` でレビュー
4. コミット
