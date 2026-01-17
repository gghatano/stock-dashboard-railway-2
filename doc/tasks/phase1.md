# Phase 1: プロジェクト構成・環境構築

## 概要

開発環境を構築し、バックエンド（FastAPI）とフロントエンド（React）がそれぞれ起動できる状態にする。この段階ではAPIロジックやUIは実装しない。

---

## サブタスク分割

| # | サブタスク | 説明 | 状態 |
|---|-----------|------|------|
| 1-1 | バックエンドディレクトリ構成 | FastAPIの最小構成を作成 | 🔵 TODO |
| 1-2 | フロントエンドプロジェクト作成 | Vite + React + TypeScript セットアップ | 🔵 TODO |
| 1-3 | 開発環境確認 | 両方の起動確認 | 🔵 TODO |

---

## ファイル構成

```
stock-dashboard-railway-2/
├── backend/
│   ├── main.py              # FastAPIアプリ（最小構成）
│   └── requirements.txt     # 依存パッケージ
└── frontend/
    ├── src/
    │   ├── App.tsx          # メインコンポーネント
    │   └── main.tsx         # エントリーポイント
    ├── index.html
    ├── package.json
    ├── tsconfig.json
    └── vite.config.ts
```

---

## 実装方針

### バックエンド (Python/FastAPI)

- **最小構成**: `/health` エンドポイントのみ
- **依存パッケージ**: fastapi, uvicorn[standard], yfinance
- **ポート**: 8000

### フロントエンド (React/TypeScript)

- **ビルドツール**: Vite（高速な開発サーバー）
- **追加パッケージ**: recharts（Phase 4で使用）
- **ポート**: 5173（Viteデフォルト）

---

## 実装例

### backend/main.py

```python
from fastapi import FastAPI
from datetime import datetime

app = FastAPI(title="Stock Dashboard API")

@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat()
    }
```

### backend/requirements.txt

```
fastapi
uvicorn[standard]
yfinance
```

### frontend/src/App.tsx

```tsx
function App() {
  return (
    <div>
      <h1>株価ダッシュボード</h1>
      <p>環境構築完了</p>
    </div>
  )
}

export default App
```

---

## 開発コマンド

### バックエンド

```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload --port 8000
```

### フロントエンド

```bash
cd frontend
npm install
npm run dev
```

### 動作確認

```bash
# バックエンド
curl http://localhost:8000/health

# フロントエンド
# ブラウザで http://localhost:5173 を開く
```

---

## 完了条件

- [ ] `backend/` ディレクトリが存在
- [ ] `backend/main.py` が存在し、FastAPIアプリが定義されている
- [ ] `backend/requirements.txt` が存在
- [ ] `uvicorn main:app --reload --port 8000` で起動確認
- [ ] `curl http://localhost:8000/health` でレスポンス確認
- [ ] `frontend/` ディレクトリが存在（Viteプロジェクト）
- [ ] `npm run dev` でフロントエンド起動確認
- [ ] ブラウザで画面表示確認

---

## 次のステップ

1. `/eng Phase 1を実装して` で実装開始
2. 完了後 `/rev` でレビュー
3. `/pm Phase 1が完了` で記録
