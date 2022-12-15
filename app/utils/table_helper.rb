module TableHelper
  def col_header(desc)
    content_tag(:th, class: 'col_header') do
      desc
    end
  end
end