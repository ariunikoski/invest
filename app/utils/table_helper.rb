module TableHelper

  # TODO move PILL_DATA and ALERT_TO_PILL to a separate file - include it here. Remove the include TableHelper from share.sbi and weekly_report_service and add instead the new file
  PILL_DATA = {
	 really_good_price: { text: 'r.good price', color: 'lightgreen', description: 'Projected yield >= 7%'},
	 good_price: { text: 'good price', color: 'olivedrab', description: 'Projected yield >= 5%'},
	 big_investment: { text: 'big investment', color: 'black', text_color: 'white', description: 'Total investement >= NIS 100,000' },
	 under_performer: { text: 'under prf.', color: 'orangered', description: 'Weighted yield <= 4%'},
	 div_overdue: { text: 'div overdue', color: 'cornflowerblue', tooltip: :div_overdue, description: 'Dividend overdue', alert_text: 'DIV OVERDUE', alert_color: 'orange'},
	 no_div_last_year: { text: 'no div last year', color: 'orange', tooltip: :no_div_last_year, description: 'No dividend last year', alert_text: 'NO DIV LAST YEAR', alert_color: 'red'},
	 div_up_25: { text: 'div up a lot', color: 'cyan', tooltip: :div_anal, description: 'Dividend YTD up by 25% or more', alert_text: 'DIV UP A LOT', alert_color: 'green'},
	 div_up: { text: 'div up', color: 'darkcyan', tooltip: :div_anal, description: 'Dividend YTD (< 25%)'},
	 div_down: { text: 'div down', color: 'mediumpurple', tooltip: :div_anal, description: 'Dividend YTD down (< 25%)'},
	 div_down_25: { text: 'div down a lot', color: 'purple', tooltip: :div_anal, text_color: 'white', description: 'Dividend YTD down by 25% or more', alert_text: 'DIV DOWN A LOT', alert_color: 'red'},
	 comments: { text: 'comments', color: 'lightgray' },
   alerts: {text: 'alerts', color: 'darkgoldenrod', description: 'Has NEW or RENEW alerts'}
  }

  ALERT_TO_PILL =
  PILL_DATA.filter_map do |pill_key, attrs|
    alert_text = attrs[:alert_text]
    [alert_text, pill_key] if alert_text
  end.to_h


  def col_header(desc, filter_name = nil, image_name = nil, extra_class = nil)
    classes = "col_header #{extra_class}"
    col_header = content_tag(:th, class: classes, onclick: "sortTable(event, this)") do
      col_header_contents(desc, filter_name, image_name)
    end
  end

  def col_header_contents(desc, filter_name, image_name)
    if filter_name
      render(partial: filter_name, locals: { desc: desc, image_name: image_name })
    else
      return desc
    end
  end

  def create_pill(pill_type, share = nil)
    data = PILL_DATA[pill_type.to_sym]
    text_color = data[:text_color] || 'black'
    share_tooltip = data[:tooltip] ? send(data[:tooltip], share) : nil
    tooltip = data[:description] || nil
    if share_tooltip
      if tooltip
        tooltip = tooltip + "\n\n" + share_tooltip
      else
        tooltip = share_tooltip
      end
    end
    content_tag(:sp, data[:text], class: 'pill', style: "background-color: #{data[:color]}; color: #{text_color}", title: tooltip )
  end
  
  def div_overdue(share)
    return nil unless share
    "Last dividend received: #{share.get_most_recent_dividend}\n" +
      "Div Overdue: #{share.div_ytd[:last_date]}"
  end
  
  def no_div_last_year(share)
    return nil unless share
    "Last dividend received: #{share.get_most_recent_dividend}"
  end
 
  def div_anal(share)
    return nil unless share
    aa = share.get_div_analyzer
    dd = aa.get_dates
    tt = aa.get_totals
    "pcnt = #{sprintf('%.2f', aa.get_pcnt)}\n" + 
      "#{dd[:start_period_a].strftime('%d/%m/%y')} - #{dd[:end_period_a].strftime('%d/%m/%y')}: #{tt[0]}\n" +
      "#{dd[:start_period_b].strftime('%d/%m/%y')} - #{dd[:end_period_b].strftime('%d/%m/%y')}: #{tt[1]}"
  end
 
  def needs_descending_button(col_order_by)
    params[:order_by] == col_order_by and params[:order_direction] != 'DESC'
  end
 
  def calc_sorter_gif(col_order_by)
    needs_descending_button(col_order_by) ? 'arrow2_s.gif' : 'arrow2_n.gif'
  end

  def string_to_pill_color(str)
    # Create a hash from the string
    hash = 0
    str.each_char do |char|
      hash = char.ord + ((hash << 5) - hash)
    end

    # Extract RGB components
    r = (hash >> 16) & 0xff
    g = (hash >> 8) & 0xff
    b = hash & 0xff

    [r, g, b]
  end

  def string_to_text_color(r, g, b, str)
    # what text color to put on the r, g, b background

    # Compute luminance (perceived brightness)
    luminance = (0.299 * r + 0.587 * g + 0.114 * b)
  
    text_color = luminance > 186 ? "black" : "white" # threshold 186 works well
    text_color
    # "background-color: rgb(#{r}, #{g}, #{b}); color: #{text_color}; " \
    # "padding: 0.3em 0.8em; border-radius: 9999px; display: inline-block;"
  end

  def create_holding_pill(holding)
    text = holding[:account]
    r, g, b = string_to_pill_color(text)
    text_color = string_to_text_color(r, g, b, text)
    tooltip = holding[:amount]
    content_tag(:sp, text, class: 'pill', style: "background-color: rgb(#{r}, #{g}, #{b}); color: #{text_color};", title: "Total holdings: #{tooltip}")
  end
end