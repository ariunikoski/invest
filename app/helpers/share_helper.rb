module ShareHelper
  include TableHelper
 
  def get_links share
    links = share.links
    sep = false
    content_tag(:span) do 
      links.each do |link|
        concat content_tag(:span, nil, style: "display: inline-block; width: 10px;") if sep
        sep = true
        #concat content_tag(:a, href: link.target_url) { link.name } - did not work for investing...
        concat content_tag(:button, nil, onclick: "navigator.clipboard.writeText('');navigator.clipboard.writeText('#{link.target_url}');win = window.open('#{link.target_url}','_blank');win.focus()") { link.name }
      end
    end
  end
end