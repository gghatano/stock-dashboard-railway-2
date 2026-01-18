import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer
} from 'recharts';
import type { ChartDataPoint, Currency } from '../types';

interface Props {
  data: ChartDataPoint[];
  currency: Currency;
  exchangeRate: number;
}

function formatDate(dateStr: string): string {
  const date = new Date(dateStr);
  return `${date.getMonth() + 1}/${date.getDate()}`;
}

function formatTooltipValue(value: number, currency: Currency): string {
  if (currency === 'JPY') {
    return `¥${Math.round(value).toLocaleString()}`;
  }
  return `$${value.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
}

export function PriceChart({ data, currency, exchangeRate }: Props) {
  const chartData = data.map(d => ({
    date: formatDate(d.date),
    close: currency === 'JPY' ? d.close * exchangeRate : d.close,
    originalDate: d.date
  }));

  // Y軸の範囲を計算（最小値・最大値に余裕を持たせる）
  const prices = chartData.map(d => d.close);
  const minPrice = Math.min(...prices);
  const maxPrice = Math.max(...prices);
  const padding = (maxPrice - minPrice) * 0.1 || maxPrice * 0.05;

  return (
    <ResponsiveContainer width="100%" height={150}>
      <LineChart data={chartData} margin={{ top: 5, right: 5, left: 5, bottom: 5 }}>
        <XAxis
          dataKey="date"
          tick={{ fontSize: 11 }}
          tickLine={false}
          axisLine={{ stroke: '#e0e0e0' }}
        />
        <YAxis
          domain={[minPrice - padding, maxPrice + padding]}
          tick={{ fontSize: 11 }}
          tickLine={false}
          axisLine={false}
          tickFormatter={(value) =>
            currency === 'JPY'
              ? `¥${(value / 1000).toFixed(0)}k`
              : `$${value.toFixed(0)}`
          }
          width={50}
        />
        <Tooltip
          formatter={(value) => {
            if (typeof value === 'number') {
              return [formatTooltipValue(value, currency), '終値'];
            }
            return [String(value), '終値'];
          }}
          labelFormatter={(label) => String(label)}
          contentStyle={{
            backgroundColor: '#fff',
            border: '1px solid #e0e0e0',
            borderRadius: '4px',
            fontSize: '12px'
          }}
        />
        <Line
          type="monotone"
          dataKey="close"
          stroke="#6366f1"
          strokeWidth={2}
          dot={{ r: 3, fill: '#6366f1' }}
          activeDot={{ r: 5, fill: '#6366f1' }}
        />
      </LineChart>
    </ResponsiveContainer>
  );
}
