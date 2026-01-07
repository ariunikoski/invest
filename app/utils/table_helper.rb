include PillData
module TableHelper
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