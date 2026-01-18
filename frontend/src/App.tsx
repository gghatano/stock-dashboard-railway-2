import { useState } from 'react';
import { useIndicesData } from './hooks/useIndicesData';
import { IndexCard } from './components/IndexCard';
import { CurrencyToggle } from './components/CurrencyToggle';
import type { Currency } from './types';
import './App.css';

function App() {
  const { data, loading, error, isFallback } = useIndicesData();
  const [currency, setCurrency] = useState<Currency>('JPY');

  const exchangeRate = data?.exchange_rate.rate ?? 157.0;

  return (
    <div className="app">
      <header className="header">
        <h1 className="title">Stock Dashboard</h1>
        <div className="header-right">
          <div className="exchange-rate">
            <span className="rate-label">USD/JPY:</span>
            <span className="rate-value">¥{exchangeRate.toFixed(2)}</span>
          </div>
          <CurrencyToggle currency={currency} onToggle={setCurrency} />
        </div>
      </header>

      <main className="main">
        {loading && (
          <div className="loading">
            <div className="spinner"></div>
            <p>Loading...</p>
          </div>
        )}

        {error && !data && (
          <div className="error">
            <p>Error: {error}</p>
          </div>
        )}

        {data && (
          <>
            {isFallback && (
              <div className="fallback-notice">
                Demo data (API unavailable)
              </div>
            )}
            <div className="cards-container">
              {data.indices.map((index) => (
                <IndexCard
                  key={index.ticker}
                  data={index}
                  currency={currency}
                  exchangeRate={exchangeRate}
                />
              ))}
            </div>
          </>
        )}
      </main>

      <footer className="footer">
        <p>Data source: Yahoo Finance</p>
      </footer>
    </div>
  );
}

export default App;
