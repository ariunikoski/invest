module TableHelper

  PILL_DATA = {
	 really_good_price: { text: 'r.good price', color: 'lightgreen' },
	 good_price: { text: 'good price', color: 'olivedrab' },
	 big_investment: { text: 'big investment', color: 'black', text_color: 'white' },
	 under_performer: { text: 'under prf.', color: 'orangered' },
	 div_overdue: { text: 'div overdue', color: 'cornflowerblue' },
	 comments: { text: 'comments', color: 'lightgray' }
  }

  def col_header(desc, filter_name = nil, image_name = nil)
    col_header = content_tag(:th, class: 'col_header') do
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

  def create_pill(pill_type)
    data = PILL_DATA[pill_type.to_sym]
    text_color = data[:text_color] || 'black'
    #puts '>>> pill_type,' pill_type, data
    content_tag(:sp, data[:text], class: 'pill', style: "background-color: #{data[:color]}; color: #{text_color}" )
  end
end