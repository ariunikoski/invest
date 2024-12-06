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
  
  def reorder_shares(original_shares)
    order_by = params[:order_by]
    retval = original_shares.sort_by(&:p_l_nis) if order_by == 'P_L'
    retval = original_shares.sort_by(&:p_l_pcnt) if order_by == 'P_L_CNT'
    return original_shares unless retval
    retval.reverse! if params[:order_direction] == 'DESC'
    retval
  end
end