import type { Currency } from '../types';
import './CurrencyToggle.css';

interface Props {
  currency: Currency;
  onToggle: (currency: Currency) => void;
}

export function CurrencyToggle({ currency, onToggle }: Props) {
  return (
    <div className="currency-toggle">
      <button
        className={`toggle-btn ${currency === 'JPY' ? 'active' : ''}`}
        onClick={() => onToggle('JPY')}
      >
        円
      </button>
      <button
        className={`toggle-btn ${currency === 'USD' ? 'active' : ''}`}
        onClick={() => onToggle('USD')}
      >
        USD
      </button>
    </div>
  );
}
