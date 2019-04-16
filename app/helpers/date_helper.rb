module DateHelper

  def format_date_with_wday(date)
    date.strftime("%m/%d(#{format_japanese_wday(date.wday)})")
  end

  def format_japanese_wday(wday)
    %w(日 月 火 水 木 金 土)[wday]
  end
end
