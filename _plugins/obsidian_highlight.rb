Jekyll::Hooks.register :documents, :pre_render do |doc|
  if doc.extname == ".md"
    doc.content.gsub!(/==(.*?)==/, '<mark>\1</mark>')
  end
end