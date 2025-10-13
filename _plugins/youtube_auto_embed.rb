# frozen_string_literal: true

Jekyll::Hooks.register [:posts, :pages], :post_convert do |doc|
  # 유튜브 링크 정규식 탐색
  youtube_regex = %r{https?://(?:www\.)?youtube\.com/watch\?v=([\w-]+)}i
  youtu_be_regex = %r{https?://youtu\.be/([\w-]+)}i

  doc.output.gsub!(youtube_regex) do
    video_id = Regexp.last_match(1)
    %Q{
<div class="video-wrapper">
  <iframe src="https://www.youtube.com/embed/#{video_id}" frameborder="0" allowfullscreen></iframe>
</div>
}
  end

  doc.output.gsub!(youtu_be_regex) do
    video_id = Regexp.last_match(1)
    %Q{
<div class="video-wrapper">
  <iframe src="https://www.youtube.com/embed/#{video_id}" frameborder="0" allowfullscreen></iframe>
</div>
}
  end
end
