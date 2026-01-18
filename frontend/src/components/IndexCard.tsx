import type { IndexData, Currency } from '../types';
import { PriceChart } from './PriceChart';
import './IndexCard.css';

interface Props {
  data: IndexData;
  currency: Currency;
  exchangeRate: number;
}

function formatCurrency(value: number, currency: Currency): string {
  if (currency === 'JPY') {
    return `¥${Math.round(value).toLocaleString()}`;
  }
  return `$${value.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
}

export function IndexCard({ data, currency, exchangeRate }: Props) {
  const price = currency === 'JPY' ? data.current_price * exchangeRate : data.current_price;
  const change = currency === 'JPY' ? data.change * exchangeRate : data.change;
  const isPositive = data.change >= 0;
  const changeSign = isPositive ? '+' : '';

  return (
    <div className={`index-card ${isPositive ? 'positive' : 'negative'}`}>
      <div className="card-header">
        <h2 className="index-name">{data.name}</h2>
        <span className="ticker">{data.ticker}</span>
      </div>

      <div className="price-section">
        <div className="current-price">{formatCurrency(price, currency)}</div>
        <div className={`change ${isPositive ? 'up' : 'down'}`}>
          <span className="change-amount">
            {changeSign}{formatCurrency(change, currency)}
          </span>
          <span className="change-percent">
            ({changeSign}{data.change_percent.toFixed(2)}%)
          </span>
          <span className="change-icon">{isPositive ? '↑' : '↓'}</span>
        </div>
      </div>

      <div className="chart-section">
        <PriceChart
          data={data.chart_data}
          currency={currency}
          exchangeRate={exchangeRate}
        />
      </div>
    </div>
  );
}
