// API レスポンス型定義（仕様書3.2節に準拠）

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
  isFallback?: boolean;
}

export type Currency = 'JPY' | 'USD';
