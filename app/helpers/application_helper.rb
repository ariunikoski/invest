module ApplicationHelper
  def header_tab(current, name, page)
    if (name == current)
      return content_tag(:span, name, class: 'current_link')
    end
    span_tag = content_tag(:span, name, class: 'page_link')
    link_to(span_tag, '/'+page, :class => 'page_link')
  end
end
