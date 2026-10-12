//+------------------------------------------------------------------+
//|                                                           DCA MA |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+


#include <Indicators\Indicators.mqh>

#include "MngDCA.mqh"

input group "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
input group "⁜⁜⁜⟪⟪ CÀI ĐẶT CHUNG ⟫⟫⁜⁜⁜"
input bool inp_trade_thuan_trend = true; // Trade Thuận Trend (false=Trade Ngược)
input ulong MagicNumber = 117; // Magic Number
input string CmtEA      = "t.me/LTCong";    // Comment Order

input group "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
input group "⁜⁜⁜⟪⟪ BUY ⟫⟫⁜⁜⁜"
input int    inp_rb_max_order      = 19;     // Số lệnh tối đa
//input group "↘↘↘ Trailing Entry ↙↙↙"
input long           inp_rb_trailing_offset = 100;      // Trailing Entry (Point) = '0' : Không Trailing
//input group "↘↘↘ Volume ↙↙↙"
ENUM_CALC_MODE inp_rb_mode_volume   = CALC_DEFINE;     // Mode tính Volume
input double         inp_rb_scale_volume  = 0.01;          // Scale Volume (x Volume toàn bộ)
double         inp_rb_fix_volume    = 0.01;         // FIX: Volume cố định (Volume đầu cho Multi/Plus)
double         inp_rb_multi_volume  = 1.33;         // MULTI: Hệ số nhân
double         inp_rb_add_volume    = 0.01;         // PLUS: Hệ số cộng
input string         inp_rb_define_volume = "1;1;2;3;5;8;13;21;34;55;89;144;233;377;610;987"; // Danh sách Volume tùy chỉnh
//input group "↘↘↘ Step ↙↙↙"
ENUM_CALC_MODE inp_rb_mode_step     = CALC_DEFINE;   // Mode tính Step (theo Point)
long           inp_rb_fix_step      = 450;         // FIX: Step cố định (Step đầu cho Multi/Plus)
double         inp_rb_multi_step    = 0.96;          // MULTI: Hệ số nhân
double         inp_rb_add_step      = 20;          // PLUS: Hệ số cộng
input string         inp_rb_define_step   = "100;150;200"; // Danh sách Step tùy chỉnh
//input group "↘↘↘ TakeProfit ↙↙↙"
ENUM_CALC_MODE inp_rb_mode_tp       = CALC_FIX;    // Mode tính TP (theo Point)
input double         inp_rb_fix_tp        = 255;         // FIX: TP cố định
double         inp_rb_multi_tp      = 0.95;          // MULTI: Hệ số nhân
double         inp_rb_add_tp        = 20;          // PLUS: Hệ số cộng
string         inp_rb_define_tp     = "50;80;120";  // DEFINE: Danh sách TP tùy chỉnh
input long  inp_rb_trailing_start = 150; // Start Trailing
input long  inp_rb_trailing_ofset = 50;   // Offset Trailing
input long  inp_rb_trailing_step = 50;   // Step Trailing

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
input group "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
input group "⁜⁜⁜⟪⟪ SELL ⟫⟫⁜⁜⁜"
input int    inp_rs_max_order      = 19;     // Số lệnh tối đa
//input group "↘↘↘ Trailing Entry ↙↙↙"
input long           inp_rs_trailing_offset = 100;      // Trailing Entry (Point) = '0' : Không Trailing
//input group "↘↘↘ Volume ↙↙↙"
ENUM_CALC_MODE inp_rs_mode_volume   = CALC_DEFINE;     // Mode tính Volume
input double         inp_rs_scale_volume  = 0.01;          // Scale Volume (x Volume toàn bộ)
double         inp_rs_fix_volume    = 0.01;         // FIX: Volume cố định (Volume đầu cho Multi/Plus)
double         inp_rs_multi_volume  = 1.33;         // MULTI: Hệ số nhân
double         inp_rs_add_volume    = 0.01;         // PLUS: Hệ số cộng
input string         inp_rs_define_volume = "1;1;2;3;5;8;13;21;34;55;89;144;233;377;610;987"; // Danh sách Volume tùy chỉnh
//input group "↘↘↘ Step ↙↙↙"
ENUM_CALC_MODE inp_rs_mode_step     = CALC_DEFINE;   // Mode tính Step (theo Point)
long           inp_rs_fix_step      = 450;         // FIX: Step cố định (Step đầu cho Multi/Plus)
double         inp_rs_multi_step    = 0.96;          // MULTI: Hệ số nhân
double         inp_rs_add_step      = 20;          // PLUS: Hệ số cộng
input string         inp_rs_define_step   = "100;150;200"; // Danh sách Step tùy chỉnh
//input group "↘↘↘ TakeProfit ↙↙↙"
ENUM_CALC_MODE inp_rs_mode_tp       = CALC_FIX;    // Mode tính TP (theo Point)
input double         inp_rs_fix_tp        = 255;         // FIX: TP cố định
double         inp_rs_multi_tp      = 0.95;          // MULTI: Hệ số nhân
double         inp_rs_add_tp        = 20;          // PLUS: Hệ số cộng
string         inp_rs_define_tp     = "50;80;120";  // DEFINE: Danh sách TP tùy chỉnh
input long  inp_rs_trailing_start = 150; // Start Trailing
input long  inp_rs_trailing_ofset = 50;   // Offset Trailing
input long  inp_rs_trailing_step = 50;   // Step Trailing


input group "▬▬▬▬▬ INDICATOR ▬▬▬▬▬"
input bool                 inp_show_indi  = false;       // Hiển thị indi-mũi tên
input ENUM_TIMEFRAMES      inp_ma_tf      = PERIOD_H1;   // MA Timeframe
input int                  inp_ma_period  = 200;         // MA Period
input int                  inp_ma_shift   = 0;           // MA Shift
input ENUM_MA_METHOD       inp_ma_method  = MODE_SMA;    // MA Mode
input ENUM_APPLIED_PRICE   inp_ma_apply   = PRICE_CLOSE; // Apply to
input double     inp_distance_up_trend = 1000;   // Khoảng cách Up Trend (Point)
input double     inp_distance_down_trend = 1000;  // Khoảng cách Down Trend (Point)
input bool        inp_first_entry_sw = true;           // Vào lệnh đầu cả khi Sideway

enum EActionNguocTrend {
   KHONG_LAM_GI_CA = 0,          // Không làm gì
   DONG_LENH_NGUOC_TREND = 1,    // Đóng lệnh ngược trend
   TIEP_TUC_DCA = 2              // Tiếp tục DCA
};
input EActionNguocTrend inp_hanhdong = TIEP_TUC_DCA; // Hành động khi ngược trend:

CiMA *hand_ma = NULL;
CIsNewBar g_new_bar;
//+------------------------------------------------------------------+
//|                                                                  |

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetParameter() {
// Khởi tạo cho BUY
   SCalcParams v_buy = {inp_rb_mode_volume, inp_rb_fix_volume, inp_rb_multi_volume, inp_rb_add_volume, inp_rb_define_volume};
   SCalcParams s_buy = {inp_rb_mode_step, (double)inp_rb_fix_step, inp_rb_multi_step, inp_rb_add_step, inp_rb_define_step};
   SCalcParams t_buy = {inp_rb_mode_tp, inp_rb_fix_tp, inp_rb_multi_tp, inp_rb_add_tp, inp_rb_define_tp};

   g_real_buy.Apply(inp_rb_max_order, inp_rb_trailing_offset, inp_rb_scale_volume, v_buy, s_buy, t_buy);

// Khởi tạo cho SELL
   SCalcParams v_sell = {inp_rs_mode_volume, inp_rs_fix_volume, inp_rs_multi_volume, inp_rs_add_volume, inp_rs_define_volume};
   SCalcParams s_sell = {inp_rs_mode_step, (double)inp_rs_fix_step, inp_rs_multi_step, inp_rs_add_step, inp_rs_define_step};
   SCalcParams t_sell = {inp_rs_mode_tp, inp_rs_fix_tp, inp_rs_multi_tp, inp_rs_add_tp, inp_rs_define_tp};

   g_real_sell.Apply(inp_rs_max_order, inp_rs_trailing_offset, inp_rs_scale_volume, v_sell, s_sell, t_sell);


   g_trailing_buy.Start = inp_rb_trailing_start * _Point;
   g_trailing_buy.Step = inp_rb_trailing_step * _Point;
   g_trailing_buy.Offset = inp_rb_trailing_ofset * _Point;

   g_trailing_sell.Start = inp_rs_trailing_start * _Point;
   g_trailing_sell.Step = inp_rs_trailing_step * _Point;
   g_trailing_sell.Offset = inp_rs_trailing_ofset * _Point;
}


//+------------------------------------------------------------------+
double GetMAValue(int idx) {
   if(hand_ma == NULL) {
      hand_ma = new CiMA();
      if(!hand_ma.Create(_Symbol, inp_ma_tf, inp_ma_period, inp_ma_shift, inp_ma_method, inp_ma_apply)) return 0.0;
      else if(inp_ma_tf == Period())hand_ma.AddToChart(0, 0);
   }
// Refresh và lấy giá trị
   hand_ma.Refresh();
   return hand_ma.Main(idx);
}
//---
int GetTrend(int idx) {
   double ma_value = GetMAValue(idx);
   double close_value = iClose(_Symbol, inp_ma_tf, idx);
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
//---
   if(close_value - ma_value >= inp_distance_up_trend * point) {
      if(!inp_trade_thuan_trend) return -1;
      return 1;
   } //---
   else if(ma_value - close_value >= inp_distance_down_trend * point) {
      if(!inp_trade_thuan_trend) return 1;
      return -1;
   }

   return 0;
}

#resource "MA Indi.ex5"
string indi_name = "::MA Indi";
int hand_custom;
string nameindicustom = "";
//+------------------------------------------------------------------+

int OnInit() {

   m_symbol.Name(_Symbol);
   m_symbol.Refresh();
   m_symbol.RefreshRates();

   m_trade.SetExpertMagicNumber(MagicNumber);
   m_trade.SetAsyncMode(true);

   hand_custom = iCustom(_Symbol, inp_ma_tf, indi_name,
                         inp_ma_period, inp_ma_shift, inp_ma_method, inp_ma_apply, inp_distance_up_trend, inp_distance_down_trend);

   if(inp_show_indi && inp_ma_tf == Period()) {
      if(ChartIndicatorAdd(0, 0, hand_custom)) {
         nameindicustom = ChartIndicatorName(0, 0, ChartIndicatorsTotal(0, 0) - 1);
      }
   }

   SetParameter();
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   if(hand_ma != NULL) {
      hand_ma.DeleteFromChart(0, 0);
      delete hand_ma;
      hand_ma = NULL;
   }
   if(nameindicustom != "") {
      ChartIndicatorDelete(0, 0, nameindicustom);
   }
   IndicatorRelease(hand_custom);
   Comment("");

   g_com.Destroy();
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result) {
   m_trade.CheckTransaction(trans, request, result);
//if(trans.type == TRADE_TRANSACTION_POSITION) GetPos(true);
}//---
//+------------------------------------------------------------------+
void CloseTarget() {
   m_trade.SetAsyncMode(true);

   for(int i = PositionsTotal() - 1; i >= 0; i--) {
      if(!m_position.SelectByIndex(i)) continue;
      if(m_position.Symbol() != m_symbol.Name()) continue;
      //if(m_position.Magic() != MagicNumber) continue;

      ulong ptk = m_position.Ticket();
      int ptype = m_position.PositionType() == POSITION_TYPE_BUY ? 1 : -1;
      PrintFormat(" Close #%I64u: Hit Target", ptk);
      arr_close.Add(ptk);
      m_trade.PositionCloseWithCmt(ptk, "HitTarget");
   }
}

//+------------------------------------------------------------------+
CComm g_com("tvl_com", false);
CComm g_com_buy("g_com_buy", true), g_com_sell("g_com_sell", true);
void OnTick() {

   if(!RefreshTick() || !CheckClose()) return;

//if(m_trade.IsWaitingBuy() || m_trade.IsWaitingSell()) return;
   bool IsWaitingBuy = m_trade.IsWaitingBuy();
   bool IsWaitingSell = m_trade.IsWaitingSell();
   if(IsWaitingBuy || IsWaitingSell) return;
   GetPos();

   int trend = GetTrend(1);

   if(inp_hanhdong == DONG_LENH_NGUOC_TREND) {
      if(trend == 1) CloseAll(-1);
      else if(trend == -1) CloseAll(1);
   }

   bool newbar = g_new_bar.IsNewBar(inp_ma_tf);

   if(!IsWaitingBuy)
      g_real_buy.TradeOnTick(newbar, trend, true, g_trailing_buy, inp_hanhdong);

   if(!IsWaitingSell)
      g_real_sell.TradeOnTick(newbar, trend, true, g_trailing_sell, inp_hanhdong);

   ShowInfoBuySell();

}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTrade(void) {
   GetPos();
}
//+------------------------------------------------------------------+
string GetTxtTrend(int count) {
   if(count <= 0) return "";
   string txt_return = StringFormat("Trend của %d nến:", count);

   for(int i = 1; i <= count; i++) {
      int trend = GetTrend(i);
      txt_return += StringFormat("\nNến %d: %s",
                                 i, trend == 1 ? "Up Trend" :
                                 trend == -1 ? "Down Trend" : "Sideway");
   }
   return txt_return;
}
//+------------------------------------------------------------------+
void ShowInfoBuySell() {
   if(IS_BACKTEST) return;
//g_com.Draw(GetTxtTrend(15));

   string infobuy = g_real_buy.GetInfo();
   string infosell = g_real_sell.GetInfo();

   g_com_buy.Draw(infobuy, CORNER_LEFT_LOWER, 8, 8, clrMediumSpringGreen); //clrDeepSkyBlue

   static uint last_width_buy = 0;
   if(last_width_buy != g_com_buy.GetWidth()) {
      g_com_sell.Destroy();
      last_width_buy = g_com_buy.GetWidth();
   }

   g_com_sell.Draw(infosell, CORNER_LEFT_LOWER, last_width_buy + 12, 8, clrHotPink);

}



//+------------------------------------------------------------------+










//+------------------------------------------------------------------+
