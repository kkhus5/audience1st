module OptionsHelper

  def render_collection_of_options(frm, collection)
    content_tag :table, :class => 'options_table hilite' do
      content = ''
      collection.each do |attrib|
        content << (render :partial => 'option', :locals => {:attrib => attrib, :f => frm}).html_safe
      end
      content.html_safe
    end
  end

  # if an option has some HTML text associated with it, sanitize the text;
  #  otherwise return the alternate text

  def sanitize_option_text(opt, tag, tag_options = {})
    s = Option.send(opt)
    content_tag(tag, sanitize(s), tag_options)
  end
  
  def link_to_if_option(opt, text, opts={})
    ((s = Option.send(opt)).blank? ?
      opts[:alt].to_s :
      content_tag(:span, link_to(text, s, opts), :id => opt, :class => opt))
  end

  def link_to_if_option_text(opt, path, html_opts={})
    if (s = Option.send(opt)).blank? then '' else
      content_tag(:span, link_to(s, path, html_opts), :id => opt, :class => opt)
    end
  end

end
