module TableHelper

  PILL_DATA = {
	 good_price: { text: 'good price', color: 'olivedrab' },
	 really_good_price: { text: 'r.good price', color: 'lightgreen' },
	 under_performer: { text: 'under prf.', color: 'orangered' },
	 div_overdue: { text: 'div overdue', color: 'cornflowerblue' }
  }

  def col_header(desc)
    content_tag(:th, class: 'col_header') do
      desc
    end
  end

  def create_pill(pill_type)
    data = PILL_DATA[pill_type.to_sym]
    #puts '>>> pill_type,' pill_type, data
    content_tag(:sp, data[:text], class: 'pill', style: "background-color: #{data[:color]}" )
  end
end