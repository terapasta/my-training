module DateHelper

  def format_date_with_wday(date)
    date.strftime("%Y/%m/%d(#{format_japanese_wday(date.wday)})")
  end

  def format_short_date_with_wday(date)
    date.strftime("%m/%d(#{format_japanese_wday(date.wday)})")
  end

  def format_japanese_wday(wday)
    %w(日 月 火 水 木 金 土)[wday]
  end

  def format_datetime(datetime)
    datetime.strftime("%Y/%m/%d %H:%M")
  end

  def get_diff_from_today(date)
    (date - Time.zone.today).to_i
  end
end
