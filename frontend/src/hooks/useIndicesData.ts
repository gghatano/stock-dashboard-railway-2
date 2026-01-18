import { useState, useEffect } from 'react';
import type { IndicesResponse, ChartDataPoint } from '../types';

// ダミーチャートデータ生成
function generateDummyChartData(basePrice: number, variance: number): ChartDataPoint[] {
  const data: ChartDataPoint[] = [];
  const today = new Date();

  for (let i = 13; i >= 0; i--) {
    const date = new Date(today);
    date.setDate(date.getDate() - i);
    // 土日をスキップ
    if (date.getDay() === 0 || date.getDay() === 6) continue;

    const randomChange = (Math.random() - 0.5) * variance;
    data.push({
      date: date.toISOString().split('T')[0],
      close: Math.round((basePrice + randomChange) * 100) / 100
    });
  }

  return data.slice(-14); // 最大14日分
}

// フォールバック用ダミーデータ
const DUMMY_DATA: IndicesResponse = {
  indices: [
    {
      ticker: "^GSPC",
      name: "S&P 500",
      current_price: 5892.45,
      previous_close: 5850.23,
      change: 42.22,
      change_percent: 0.72,
      chart_data: generateDummyChartData(5850, 100),
      last_update: new Date().toISOString()
    },
    {
      ticker: "^NYFANG",
      name: "FANG+",
      current_price: 12345.67,
      previous_close: 12300.00,
      change: 45.67,
      change_percent: 0.37,
      chart_data: generateDummyChartData(12300, 200),
      last_update: new Date().toISOString()
    }
  ],
  exchange_rate: {
    rate: 157.32,
    last_update: new Date().toISOString()
  },
  timestamp: new Date().toISOString(),
  isFallback: true
};

interface UseIndicesDataResult {
  data: IndicesResponse | null;
  loading: boolean;
  error: string | null;
  isFallback: boolean;
}

export function useIndicesData(): UseIndicesDataResult {
  const [data, setData] = useState<IndicesResponse | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [isFallback, setIsFallback] = useState(false);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch('/api/indices');

        if (!response.ok) {
          throw new Error(`HTTP error: ${response.status}`);
        }

        const result: IndicesResponse = await response.json();
        setData(result);
        setIsFallback(result.isFallback ?? false);
      } catch (err) {
        console.error('Failed to fetch indices data:', err);
        // ユーザーフレンドリーなエラーメッセージ
        const message = err instanceof Error
          ? (err.message.includes('fetch') || err.message.includes('Failed')
            ? 'バックエンドに接続できません'
            : err.message)
          : 'Unknown error';
        setError(message);
        // フォールバック: ダミーデータを使用
        setData(DUMMY_DATA);
        setIsFallback(true);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  return { data, loading, error, isFallback };
}
