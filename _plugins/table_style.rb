# encoding: utf-8

Jekyll::Hooks.register [:documents, :pages], :post_render do |doc|
  if doc.respond_to?(:output_ext) && doc.output_ext == '.html' && doc.output
    # <div class="table-wrapper"> ... </div> 블록 내부만 제한적으로 찾아서 치환
    doc.output.gsub!(/<div class="table-wrapper"(.*?)>(.*?)<\/div>/m) do
      wrapper_attr = $1
      inner_html = $2

      # 해당 블록(일반 표) 내부의 table, th, td 태그에만 인라인 스타일 주입
      inner_html.gsub!(/<table(.*?)>/, '<table\1 style="width: 100% !important; table-layout: fixed !important;">')
      inner_html.gsub!(/<th(.*?)>/, '<th\1 style="white-space: normal !important; word-break: keep-all !important; overflow-wrap: break-word !important;">')
      inner_html.gsub!(/<td(.*?)>/, '<td\1 style="white-space: normal !important; word-break: keep-all !important; overflow-wrap: break-word !important;">')

      # 치환된 내부 내용을 다시 table-wrapper로 감싸서 반환 (가로 스크롤 숨김 추가)
      "<div class=\"table-wrapper\"#{wrapper_attr} style=\"overflow-x: hidden !important;\">#{inner_html}</div>"
    end
  end
end