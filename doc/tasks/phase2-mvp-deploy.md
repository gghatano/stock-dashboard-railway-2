# 📋 タスク設計書: Phase 2 - MVP画面構築＆Railwayデプロイ
━━━━━━━━━━━━━━━━━━━━━━━━

## 概要

S&P500とFANG+インデックスを表示するダッシュボードのMVP（Minimum Viable Product）を構築し、Railwayにデプロイして外部からアクセス可能にする。

**ゴール**:
1. ローカルで動作（backend + frontend）
2. Railwayにデプロイして外部URLでアクセス可能
3. 画面に最低限の情報が表示される（実データが不安定でもUIスケルトン＋ダミーデータで成立）

**デプロイ方式**: FastAPIが`frontend/dist`を静的配信（A方式）

---

## 現状（Phase 1完了時点）

### Backend (`backend/`)
| 項目 | 状態 |
|------|------|
| main.py | ✅ 存在（FastAPI + CORS設定済み） |
| `/health` | ✅ 実装済み |
| `/api/indices` | ❌ 未実装 |
| 依存管理 | pyproject.toml (uv使用) |
| yfinance | ✅ 依存に含まれる |

### Frontend (`frontend/`)
| 項目 | 状態 |
|------|------|
| Vite + React + TS | ✅ 構成済み |
| recharts | ✅ 導入済み |
| App.tsx | 骨格のみ |
| components/ | ❌ 未作成 |
| hooks/ | ❌ 未作成 |
| types/ | ❌ 未作成 |

---

## サブタスク分割

| # | サブタスク | 説明 | 依存 |
|---|-----------|------|------|
| 2-1 | 型定義作成 | `types/index.ts` - API レスポンス型 | - |
| 2-2 | useIndicesDataフック | API取得＋ダミーフォールバック | 2-1 |
| 2-3 | IndexCardコンポーネント | 価格・前日比表示カード | 2-1 |
| 2-4 | PriceChartコンポーネント | 14日チャート（Recharts） | 2-1 |
| 2-5 | CurrencyToggleコンポーネント | 通貨切替UI（枠のみ） | - |
| 2-6 | App.tsxレイアウト | 全体レイアウト統合 | 2-2〜2-5 |
| 2-7 | /api/indicesエンドポイント | yfinance取得＋フォールバック | - |
| 2-8 | 静的配信設定 | FastAPIでfrontend/dist配信 | 2-7 |
| 2-9 | Railway設定 | nixpacks.toml作成 | - |
| 2-10 | 動作確認・README更新 | ローカル＆デプロイ確認 | 2-1〜2-9 |

---

## ファイル構成

```
stock-dashboard-railway-2/
├── backend/
│   ├── main.py              # 追記: /api/indices, 静的配信
│   └── pyproject.toml       # 既存（変更なし）
├── frontend/
│   ├── src/
│   │   ├── types/
│   │   │   └── index.ts     # 新規: 型定義
│   │   ├── hooks/
│   │   │   └── useIndicesData.ts  # 新規: データ取得フック
│   │   ├── components/
│   │   │   ├── IndexCard.tsx      # 新規: インデックスカード
│   │   │   ├── PriceChart.tsx     # 新規: 線グラフ
│   │   │   └── CurrencyToggle.tsx # 新規: 通貨切替（枠）
│   │   ├── App.tsx          # 修正: レイアウト実装
│   │   ├── App.css          # 修正: スタイル追加
│   │   └── index.css        # 修正: 基本スタイル
│   ├── package.json         # 既存（変更なし）
│   └── vite.config.ts       # 既存（変更なし）
├── nixpacks.toml            # 新規: Railway設定
└── README.md                # 追記: デプロイ手順
```

---

## 実装方針

### 1. フロントエンド（UI優先）

#### 型定義 (`types/index.ts`)
```typescript
// 仕様書3.2節に準拠
export interface ChartDataPoint {
  date: string;    // YYYY-MM-DD
  close: number;   // 終値（USD）
}

export interface IndexData {
  ticker: string;
  name: string;
  current_price: number;
  previous_close: number;
  change: number;
  change_percent: number;
  chart_data: ChartDataPoint[];
  last_update: string;
}

export interface ExchangeRate {
  rate: number;
  last_update: string;
}

export interface IndicesResponse {
  indices: IndexData[];
  exchange_rate: ExchangeRate;
  timestamp: string;
  isFallback?: boolean;  // フォールバック状態
}
```

#### useIndicesDataフック
- `/api/indices` をfetch
- 取得失敗時はダミーデータを返す（UI継続）
- ローディング・エラー状態管理

#### コンポーネント設計
- **IndexCard**: name, current_price, change, change_percent, 上昇/下落色分け
- **PriceChart**: Recharts LineChart, 14日分, レスポンシブ
- **CurrencyToggle**: JPY/USD切替ボタン（Phase 2では機能未実装、枠のみ）

### 2. バックエンド

#### /api/indices エンドポイント
```python
@app.get("/api/indices")
async def get_indices():
    try:
        # yfinanceでデータ取得
        # ^GSPC (S&P500), ^NYFANG (FANG+), USDJPY=X
        return { "indices": [...], "exchange_rate": {...}, "timestamp": "...", "isFallback": False }
    except Exception:
        # フォールバック: ダミーデータ返却
        return { ..., "isFallback": True }
```

#### 静的配信設定
```python
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse

# APIルートを先に定義（衝突回避）
# 静的ファイル配信
app.mount("/assets", StaticFiles(directory="frontend/dist/assets"), name="assets")

@app.get("/{full_path:path}")
async def serve_spa(full_path: str):
    return FileResponse("frontend/dist/index.html")
```

### 3. Railway設定

**採用方式**: `nixpacks.toml`

理由:
- Railwayのデフォルトビルドシステム
- Node.js（build）→ Python（start）の2段階制御可能
- 最小構成で確実

```toml
[phases.setup]
nixPkgs = ["nodejs_20", "python312", "gcc"]

[phases.build]
cmds = [
    "cd frontend && npm ci && npm run build"
]

[start]
cmd = "uvicorn backend.main:app --host 0.0.0.0 --port ${PORT:-8000}"
```

---

## 実装例（疑似コード）

### IndexCard.tsx
```tsx
interface Props {
  data: IndexData;
  currency: 'JPY' | 'USD';
  exchangeRate: number;
}

function IndexCard({ data, currency, exchangeRate }: Props) {
  const price = currency === 'JPY' ? data.current_price * exchangeRate : data.current_price;
  const change = currency === 'JPY' ? data.change * exchangeRate : data.change;
  const isPositive = data.change >= 0;

  return (
    <div className={`index-card ${isPositive ? 'positive' : 'negative'}`}>
      <h2>{data.name}</h2>
      <div className="price">{formatCurrency(price, currency)}</div>
      <div className="change">
        {formatCurrency(change, currency)} ({data.change_percent.toFixed(2)}%)
      </div>
      <PriceChart data={data.chart_data} currency={currency} exchangeRate={exchangeRate} />
    </div>
  );
}
```

### PriceChart.tsx
```tsx
import { LineChart, Line, XAxis, YAxis, Tooltip, ResponsiveContainer } from 'recharts';

function PriceChart({ data, currency, exchangeRate }) {
  const chartData = data.map(d => ({
    date: d.date,
    close: currency === 'JPY' ? d.close * exchangeRate : d.close
  }));

  return (
    <ResponsiveContainer width="100%" height={150}>
      <LineChart data={chartData}>
        <XAxis dataKey="date" />
        <YAxis domain={['auto', 'auto']} />
        <Tooltip />
        <Line type="monotone" dataKey="close" stroke="#8884d8" dot={false} />
      </LineChart>
    </ResponsiveContainer>
  );
}
```

### ダミーデータ（フォールバック用）
```typescript
export const DUMMY_DATA: IndicesResponse = {
  indices: [
    {
      ticker: "^GSPC",
      name: "S&P 500",
      current_price: 5892.45,
      previous_close: 5850.23,
      change: 42.22,
      change_percent: 0.72,
      chart_data: generateDummyChartData(5800, 5900),
      last_update: new Date().toISOString()
    },
    {
      ticker: "^NYFANG",
      name: "FANG+",
      current_price: 12345.67,
      previous_close: 12300.00,
      change: 45.67,
      change_percent: 0.37,
      chart_data: generateDummyChartData(12000, 12500),
      last_update: new Date().toISOString()
    }
  ],
  exchange_rate: { rate: 157.32, last_update: new Date().toISOString() },
  timestamp: new Date().toISOString(),
  isFallback: true
};
```

---

## 完了条件

### ローカル
- [ ] `npm run build` が成功（frontend/dist生成）
- [ ] `uvicorn backend.main:app` で起動
- [ ] `/health` が `{"status":"healthy"}` を返す
- [ ] `/api/indices` がJSON返却（実データ or フォールバック）
- [ ] `/` で画面表示（2カード＋チャート）
- [ ] API失敗時もUIが崩れない

### Railway
- [ ] デプロイ成功
- [ ] 外部URLで画面表示
- [ ] `/api/indices` が動作
- [ ] 取得失敗でも画面が成立

### `/rev` でレビュー完了
- [ ] コード品質チェック
- [ ] 仕様書との整合性確認

---

## 注意事項

1. **^NYFANG取得失敗の可能性**
   - yfinanceで取得できない場合あり
   - 必ずフォールバックで対応

2. **CORS設定**
   - 開発時: localhost許可（既存設定維持）
   - 本番: 同一オリジンのため不要

3. **通貨切替機能**
   - Phase 2ではUI枠のみ
   - 実機能はPhase 5で実装

4. **静的配信のパス順序**
   - `/api/*` を先に定義
   - `/health` を先に定義
   - 最後にSPAフォールバック

━━━━━━━━━━━━━━━━━━━━━━━━
## 📋 次のステップ

1. `/eng phase2-mvp-deploy.md を実装して`
2. ローカル動作確認
3. `/rev` でレビュー
4. Railwayデプロイ
5. `/pm Phase 2完了` でステータス更新
