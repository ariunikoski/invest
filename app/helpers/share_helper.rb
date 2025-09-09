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
  
  def arrow_image_classes(col_order_by)
    additional = col_order_by == params[:order_by] ? 'current' : ''
    "arrow_16 #{additional}"
  end
  
  def get_badge_filters
    badge_filters = []
    badge_filters << badge_text_for(:really_good_price)
    badge_filters << [badge_text_for(:really_good_price), badge_text_for(:good_price)]
    badge_filters << badge_text_for(:big_investment)
    badge_filters << badge_text_for(:under_performer)
    badge_filters << badge_text_for(:div_overdue)
    badge_filters << badge_text_for(:no_div_last_year)
    badge_filters << badge_text_for(:div_up_25)
    badge_filters << [badge_text_for(:div_up_25), badge_text_for(:div_up)]
    badge_filters << badge_text_for(:div_down_25)
    badge_filters << [badge_text_for(:div_down_25), badge_text_for(:div_down)]
    badge_filters << badge_text_for(:comments)
    badge_filters
  end

  def badge_text_for(badge_type)
    PILL_DATA[badge_type][:text]
  end
end