module DateHelper

  def format_date_with_wday(date)
    date.strftime("%m/%d(#{format_japanese_wday(date.wday)})")
  end

  def format_japanese_wday(wday)
    case wday
    when 0
      '日'
    when 1
      '月'
    when 2
      '火'
    when 3
      '水'
    when 4
      '木'
    when 5
      '金'
    when 6
      '土'
    else
      '？'
    end
  end
end
