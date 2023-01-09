module ShareHelper
  include TableHelper
 
  def get_links share
    links = share.links
    sep = false
    content_tag(:span) do 
      links.each do |link|
        concat content_tag(:span, nil, style: "display: inline-block; width: 10px;") if sep
        sep = true
        concat content_tag(:button, nil, onclick: "navigator.clipboard.writeText('');navigator.clipboard.writeText('#{link.target_url}');win = window.open('#{link.target_url}','_blank');win.focus()") { link.name }
      end
      concat content_tag(:button, nil, onclick: "callYahooHistoricals(#{share.id});") { 'Load Yahoo Dividends' }

    end
  end
  
  def format_number(num, precision = 0)
    # num ? ActiveSupport::NumberHelper.number_to_delimited(num, :delimited, precision: precision) : nil
    return '' unless num
    whole, decimal = num.to_s.split('.')
    if whole.to_i < -999 || whole.to_i > 999
      whole.reverse!.gsub!(/(\d{3})(?=\d)/, '\\1,').reverse!
    end
    return whole if precision < 1
    decimal = '00' if !decimal
    out_decimal = (decimal + '00')[0..1]
    [whole, out_decimal].compact.join('.')
  end
  
  def convert_to_nis(rate_table,  currency_code, amount)
    puts '>>> convert_to_nis: ', rate_table, currency_code, amount
    converted = currency_code == 'NIS' ? amount : rate_table[currency_code] * (amount || 0)
    divide_by_100?(currency_code) ? converted/100 : converted
  end
  
  def divide_by_100?(currency_code)
    currency_code == 'NIS'
  end
end