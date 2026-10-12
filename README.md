# DCA-MA: Multi-Tier Dollar Cost Averaging & Trend Grid System for MT5

An algorithmic trading Expert Advisor (EA) built for **MetaTrader 5 (MT5)**, integrating dynamic **Dollar Cost Averaging (DCA)** grid strategies with a **Moving Average (MA) trend filter**, Fibonacci/custom volume progression, and asynchronous risk management.

---

## 📌 Key Architectural Features

- **Multi-Mode Position Sizing Engine:**
  - Configurable volume calculation modes: Fixed Volume, Geometric Progression (Multiplier), Arithmetic Progression (Plus), and **Fibonacci / Custom Sequence** (e.g., `1;1;2;3;5;8;13;...`).
  - Independent configurations for both `BUY` and `SELL` grid sequences.
- **Adaptive Grid Step & Take Profit Matrix:**
  - Multi-tier distance progression between averaging orders (Fixed, Multiplied, Incremental, or Custom Defined Point arrays).
  - Dynamic TP calculation with integrated multi-level Trailing Stop mechanisms (`Trailing Start`, `Trailing Step`, `Trailing Offset`).
- **Moving Average Trend Identification Engine:**
  - Computes trend state based on the deviation distance (in points) between price and customizable MA periods (SMA/EMA on any timeframe, default H1/200).
  - Distinguishes between **Up Trend**, **Down Trend**, and **Sideway** markets.
  - Directional control: Trade with the trend (Trend-following) or against the trend (Mean-reversion).
- **Adverse Trend Shift Protection:**
  - Configurable actions when trend flips: Close counter-trend positions immediately or sustain DCA grid recovery.
  - Option to execute initial entries during Sideway consolidations.
- **Low-Latency Execution:**
  - Built with asynchronous trade execution (`SetAsyncMode(true)`) to minimize slippage and latency during multi-order operations.
  - Integrated on-chart dashboard displaying real-time grid metrics, pending steps, and active volume.

---

## 🛠 Tech Stack & Architecture

- **Language:** MQL5 (MetaQuotes Language 5)
- **Platform:** MetaTrader 5 (MT5)
- **Core Concepts:** Object-Oriented Programming (OOP via custom classes `CiMA`, `CComm`, `CIsNewBar`), Event-Driven Execution (`OnTick`, `OnTradeTransaction`), Asynchronous Order Routing.
- **Resource Linking:** Embedded compiled indicator integration (`#resource "MA Indi.ex5"`).

---

## ⚙️ Core Parameters Overview

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `inp_trade_thuan_trend` | `bool` | Toggle Trend-Following (`true`) or Counter-Trend (`false`) |
| `inp_rb_mode_volume` | `ENUM` | Volume calculation mode (`CALC_DEFINE`, `CALC_FIX`, etc.) |
| `inp_rb_define_volume`| `string` | Custom volume array sequence (e.g., Fibonacci grid) |
| `inp_ma_period` / `tf` | `int` / `ENUM` | Moving Average period and timeframe for trend detection |
| `inp_distance_up_trend` | `double` | Minimum deviation points required to trigger an Up Trend |
| `inp_hanhdong` | `enum` | Action on trend reversal: `DONG_LENH_NGUOC_TREND` or `TIEP_TUC_DCA` |

---

## ⚠️ Disclaimer
*This repository contains algorithmic trading logic for educational, testing, and portfolio demonstration purposes. Extensive backtesting and forward-testing on demo accounts are essential prior to live capital deployment.*

