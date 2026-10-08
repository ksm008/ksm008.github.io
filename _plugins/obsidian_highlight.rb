# encoding: utf-8

Jekyll::Hooks.register :documents, :pre_render do |doc|
  if doc.extname == '.md'
    doc.content = doc.content.gsub(/==([🔴🟠🟡🟢🔵🟣]?)(.*?)==/) do
      emoji = $1
      text = $2
      
      style = case emoji
              when '🔴' then 'background-color: #ffcdd2; color: #b71c1c;'
              when '🟠' then 'background-color: #ffe0b2; color: #e65100;'
              when '🟡' then 'background-color: #fff9c4; color: #f57f17;'
              when '🟢' then 'background-color: #c8e6c9; color: #1b5e20;'
              when '🔵' then 'background-color: #bbdefb; color: #0d47a1;'
              when '🟣' then 'background-color: #e1bee7; color: #4a148c;'
              else 'background-color: #ffea00; color: #000;' # 기본값 (이모지 없음)
              end
                    
      "<mark style=\"padding: 0.1em 0.3em; border-radius: 4px; #{style}\">#{text}</mark>"
    end
  end
end