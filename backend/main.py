import os
from pathlib import Path
from datetime import datetime, timedelta
from typing import Optional

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
import yfinance as yf

app = FastAPI(title="Stock Dashboard API")

# CORS設定（開発時のみ必要、本番は同一オリジン）
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173", "http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# インデックス定義
INDICES = {
    "^GSPC": {"name": "S&P 500", "currency": "USD"},
    "^NYFANG": {"name": "FANG+", "currency": "USD"},
}

# フォールバック用ダミーデータ
def get_fallback_data():
    """API取得失敗時のフォールバックデータ"""
    now = datetime.now()

    def generate_dummy_chart(base_price: float, variance: float):
        data = []
        for i in range(14, 0, -1):
            date = now - timedelta(days=i)
            if date.weekday() < 5:  # 平日のみ
                import random
                price = base_price + random.uniform(-variance, variance)
                data.append({
                    "date": date.strftime("%Y-%m-%d"),
                    "close": round(price, 2)
                })
        return data[-14:]  # 最大14件

    return {
        "indices": [
            {
                "ticker": "^GSPC",
                "name": "S&P 500",
                "current_price": 5892.45,
                "previous_close": 5850.23,
                "change": 42.22,
                "change_percent": 0.72,
                "chart_data": generate_dummy_chart(5850, 50),
                "last_update": now.isoformat()
            },
            {
                "ticker": "^NYFANG",
                "name": "FANG+",
                "current_price": 12345.67,
                "previous_close": 12300.00,
                "change": 45.67,
                "change_percent": 0.37,
                "chart_data": generate_dummy_chart(12300, 100),
                "last_update": now.isoformat()
            }
        ],
        "exchange_rate": {
            "rate": 157.32,
            "last_update": now.isoformat()
        },
        "timestamp": now.isoformat(),
        "isFallback": True
    }


def get_index_data(ticker: str) -> Optional[dict]:
    """インデックスデータを取得"""
    try:
        stock = yf.Ticker(ticker)

        # 14日分のデータを取得
        hist = stock.history(period="1mo")
        if hist.empty:
            return None

        # チャートデータ作成（直近14営業日）
        chart_data = []
        for date, row in hist.tail(14).iterrows():
            chart_data.append({
                "date": date.strftime("%Y-%m-%d"),
                "close": round(row["Close"], 2)
            })

        # 現在価格と前日終値
        current_price = round(hist["Close"].iloc[-1], 2)
        previous_close = round(hist["Close"].iloc[-2], 2) if len(hist) > 1 else current_price
        change = round(current_price - previous_close, 2)
        change_percent = round((change / previous_close) * 100, 2) if previous_close else 0

        return {
            "ticker": ticker,
            "name": INDICES.get(ticker, {}).get("name", ticker),
            "current_price": current_price,
            "previous_close": previous_close,
            "change": change,
            "change_percent": change_percent,
            "chart_data": chart_data,
            "last_update": datetime.now().isoformat()
        }
    except Exception as e:
        print(f"Error fetching {ticker}: {e}")
        return None


def get_exchange_rate() -> Optional[dict]:
    """ドル円レートを取得"""
    try:
        usdjpy = yf.Ticker("USDJPY=X")
        hist = usdjpy.history(period="1d")
        if hist.empty:
            return None

        rate = round(hist["Close"].iloc[-1], 2)
        return {
            "rate": rate,
            "last_update": datetime.now().isoformat()
        }
    except Exception as e:
        print(f"Error fetching exchange rate: {e}")
        return None


@app.get("/health")
def health_check():
    """ヘルスチェックエンドポイント"""
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat()
    }


@app.get("/api/indices")
def get_indices():
    """インデックスデータを取得するAPIエンドポイント"""
    try:
        indices = []
        is_fallback = False

        # 各インデックスのデータを取得
        for ticker in INDICES.keys():
            data = get_index_data(ticker)
            if data:
                indices.append(data)
            else:
                is_fallback = True

        # 為替レート取得
        exchange_rate = get_exchange_rate()
        if not exchange_rate:
            is_fallback = True
            exchange_rate = {"rate": 157.0, "last_update": datetime.now().isoformat()}

        # データが取得できなかった場合はフォールバック
        if not indices:
            return get_fallback_data()

        return {
            "indices": indices,
            "exchange_rate": exchange_rate,
            "timestamp": datetime.now().isoformat(),
            "isFallback": is_fallback
        }
    except Exception as e:
        print(f"Error in get_indices: {e}")
        return get_fallback_data()


# 静的ファイル配信（本番用）
# frontend/dist が存在する場合のみマウント
FRONTEND_DIR = Path(__file__).parent.parent / "frontend" / "dist"

if FRONTEND_DIR.exists():
    # 静的アセット配信
    assets_dir = FRONTEND_DIR / "assets"
    if assets_dir.exists():
        app.mount("/assets", StaticFiles(directory=str(assets_dir)), name="assets")

    @app.get("/")
    async def serve_root():
        """ルートパスでindex.htmlを返す"""
        return FileResponse(str(FRONTEND_DIR / "index.html"))

    @app.get("/{full_path:path}")
    async def serve_spa(full_path: str):
        """SPA用: 未知のパスはindex.htmlを返す"""
        file_path = FRONTEND_DIR / full_path
        if file_path.exists() and file_path.is_file():
            return FileResponse(str(file_path))
        return FileResponse(str(FRONTEND_DIR / "index.html"))
