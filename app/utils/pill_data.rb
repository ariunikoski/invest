module PillData
  PILL_DATA = {
	 really_good_price: { text: 'r.good price', color: 'lightgreen', description: 'Projected yield >= 7%', tooltip: :div_ytd, alert_text: 'REALLY GOOD BUY', alert_color: 'darkgreen'},
	 good_price: { text: 'good price', color: 'olivedrab', description: 'Projected yield >= 5%'},
	 big_investment: { text: 'big investment', color: 'black', text_color: 'white', description: 'Total investement >= NIS 100,000' },
	 under_performer: { text: 'under prf.', color: 'orangered', description: 'Weighted yield <= 4%', tooltip: :div_weighted_ytd, alert_text: 'UNDER PERFORMER', alert_color: 'firebrick'},
	 div_overdue: { text: 'div overdue', color: 'cornflowerblue', tooltip: :div_overdue, description: 'Dividend overdue', alert_text: 'DIV OVERDUE', alert_color: 'firebrick'},
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

  def div_overdue(share)
    return nil unless share
    "Last dividend received: #{share.get_most_recent_dividend}\n" +
      "Div Overdue: #{share.div_ytd[:last_date]}"
  end
  
  def no_div_last_year(share)
    return nil unless share
    "Last dividend received: #{share.get_most_recent_dividend}"
  end
  
  def div_ytd(share)
    return nil unless share
    "YTD dividend yield: #{sprintf('%.2f', share.div_ytd[:ytd_pcnt])}"
  end
  
  def div_weighted_ytd(share)
    return nil unless share
    "Weighted YTD dividend yield: #{sprintf('%.2f', share.div_ytd[:weighted_ytd])}"
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
end