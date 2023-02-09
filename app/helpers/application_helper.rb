module ApplicationHelper
  def header_tab(current, name, page)
    if (name == current)
      return content_tag(:span, name, class: 'current_link')
    end
    span_tag = content_tag(:span, name, class: 'page_link')
    link_to(span_tag, '/'+page, :class => 'page_link')
  end
  
  def inner_tab(current, name)
    if (name == current)
      span_tag = content_tag(:span, name, id: "tab_header_#{name}", class: 'current_link small_tab', onclick: "show_inner_tab(this, '#{inner_tab_key(name)}')")
    else
      span_tag = content_tag(:span, name, id: "tab_header_#{name}", class: 'page_link small_tab', onclick: "show_inner_tab(this, '#{inner_tab_key(name)}')")
    end
    span_tag
  end
  
  def inner_tab_key(name)
    "inner_tab_#{name}"
  end
  
  def inner_tab_data(current, name, partial_name, locals, extra_klass = '')
    klass = (current == name) ? '' : 'hidden'
    content_tag(:div, render(partial: partial_name, locals: locals), class: "inner_tab_data #{klass} #{extra_klass}", id: "#{inner_tab_key(name)}")
  end
end
