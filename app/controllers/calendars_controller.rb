class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)今日が2月1日の場合・・・ Date.today.day => 1日
    @week_days = []
     # 空の配列をインスタンス変数に代入
    plans = Plan.where(date: @todays_date..@todays_date + 6)
     # Plansテーブルのdateカラムからwhereメソッドで必要なデータを取ってplansに代入
    7.times do |x|
      today_plans = []
      plan = plans.map do |plan|
        # ここのmapはeach文と捉える
        today_plans.push(plan.plan) if plan.date == @todays_date + x
        # 変数planからplanカラムの情報だけをtodays.planにpushする
      end
      wday_num = Date.today.wday+x #Date.today.wdayを利用して添字となる数値を得る
      days = { month: (@todays_date + x).month, date: (@todays_date+x).day, plans: today_plans, wday: wdays[wday_num] }
      @week_days.push(days)
      # 39-40行目はビューに使う
    end
  end
end
