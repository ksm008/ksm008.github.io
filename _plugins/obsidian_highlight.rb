# encoding: utf-8

Jekyll::Hooks.register :documents, :pre_render do |doc|
  if doc.extname == '.md'
    # 마크다운 텍스트를 코드 블록(```...```)과 인라인 코드(`...`) 기준으로 분리
    doc.content = doc.content.split(/(```.*?```|`[^`\n]+`)/m).map do |chunk|
      # 코드로 감싸진 부분은 하이라이트 변환을 건너뛰고 그대로 반환
      if chunk.start_with?('`')
        chunk 
      else
        # 코드가 아닌 일반 텍스트 영역에만 하이라이트 정규식 적용
        chunk.gsub(/==([🔴🟠🟡🟢🔵🟣]?)(.*?)==/) do
          emoji = $1
          text = $2
          
          style = case emoji
                  when '🔴' then 'background-color: #ffcdd2; color: #b71c1c;'
                  when '🟠' then 'background-color: #ffe0b2; color: #e65100;'
                  when '🟡' then 'background-color: #fff9c4; color: #f57f17;'
                  when '🟢' then 'background-color: #c8e6c9; color: #1b5e20;'
                  when '🔵' then 'background-color: #bbdefb; color: #0d47a1;'
                  when '🟣' then 'background-color: #e1bee7; color: #4a148c;'
                  else 'background-color: #ffea00; color: #000;'
                  end
                        
          "<mark style=\"padding: 0.1em 0.3em; border-radius: 4px; #{style}\">#{text}</mark>"
        end
      end
    end.join
  end
end