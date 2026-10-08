# encoding: utf-8

Jekyll::Hooks.register :documents, :pre_render do |doc|
  if doc.extname == '.md'
    doc.content = doc.content.gsub(/==([🔴🟠🟡🟢🔵🟣]?)(.*?)==/) do
      emoji = $1
      text = $2
      
      color_class = case emoji
                    when '🔴' then 'hl-red'
                    when '🟠' then 'hl-orange'
                    when '🟡' then 'hl-yellow'
                    when '🟢' then 'hl-green'
                    when '🔵' then 'hl-blue'
                    when '🟣' then 'hl-purple'
                    else 'hl-default'
                    end
                    
      "<mark class=\"#{color_class}\">#{text}</mark>"
    end
  end
end