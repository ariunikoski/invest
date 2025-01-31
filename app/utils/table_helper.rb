module TableHelper

  PILL_DATA = {
	 really_good_price: { text: 'r.good price', color: 'lightgreen', description: 'Projected yield >= 7%'},
	 good_price: { text: 'good price', color: 'olivedrab', description: 'Projected yield >= 5%'},
	 big_investment: { text: 'big investment', color: 'black', text_color: 'white', description: 'Total investement >= NIS 100,000' },
	 under_performer: { text: 'under prf.', color: 'orangered', description: 'Weighted yield <= 4%'},
	 div_overdue: { text: 'div overdue', color: 'cornflowerblue', tooltip: :div_overdue, description: 'Dividend overdue'},
	 no_div_last_year: { text: 'no div last year', color: 'orange', tooltip: :no_div_last_year, description: 'No dividend last year'},
	 div_up_25: { text: 'div up a lot', color: 'cyan', tooltip: :div_anal, description: 'Dividend YTD up by 25% or more'},
	 div_up: { text: 'div up', color: 'darkcyan', tooltip: :div_anal, description: 'Dividend YTD (< 25%)'},
	 div_down: { text: 'div down', color: 'mediumpurple', tooltip: :div_anal, description: 'Dividend YTD down (< 25%)'},
	 div_down_25: { text: 'div down a lot', color: 'purple', tooltip: :div_anal, text_color: 'white', description: 'Dividend YTD down by 25% or more'},
	 comments: { text: 'comments', color: 'lightgray' }
  }

  def col_header(desc, filter_name = nil, image_name = nil, extra_class = nil)
    classes = "col_header #{extra_class}"
    col_header = content_tag(:th, class: classes) do
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
end