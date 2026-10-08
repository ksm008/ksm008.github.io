# encoding: utf-8

Jekyll::Hooks.register [:documents, :pages], :post_render do |doc|
  if doc.respond_to?(:output_ext) && doc.output_ext == '.html' && doc.output
    # 테이블 래퍼의 가로 스크롤 숨김
    doc.output.gsub!(/<div class="table-wrapper"(.*?)>/, '<div class="table-wrapper"\1 style="overflow-x: hidden !important;">')
    
    # 테이블 너비 고정
    doc.output.gsub!(/<table(.*?)>/, '<table\1 style="width: 100% !important; table-layout: fixed !important;">')
    
    # th, td에 텍스트 줄바꿈 강제 적용
    doc.output.gsub!(/<th(.*?)>/, '<th\1 style="white-space: normal !important; word-break: keep-all !important; overflow-wrap: break-word !important;">')
    doc.output.gsub!(/<td(.*?)>/, '<td\1 style="white-space: normal !important; word-break: keep-all !important; overflow-wrap: break-word !important;">')
  end
end