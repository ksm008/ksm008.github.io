(function () {
  // 변환을 적용할 컨테이너들(Chirpy 호환, 범용 선택자)
  const CONTAINERS = [
    '.post-content', '.post', 'article', 'main', '.page'
  ];

  // 이미 iframe이거나 코드 블록은 건너뛴다
  const isInsideCode = (el) =>
    el.closest('pre, code, kbd, samp') !== null;

  // 유튜브 URL 판별 (youtube.com/watch?v=..., youtu.be/..., shorts/..., embed/...)
  const YT_PATTERNS = [
    /https?:\/\/(?:www\.)?youtube\.com\/watch\?v=([\w-]{11})([^\s]*)?/i,
    /https?:\/\/youtu\.be\/([\w-]{11})([^\s]*)?/i,
    /https?:\/\/(?:www\.)?youtube\.com\/shorts\/([\w-]{11})([^\s]*)?/i,
    /https?:\/\/(?:www\.)?youtube\.com\/embed\/([\w-]{11})([^\s]*)?/i
  ];

  // t=1m30s 같은 시작 시간 파라미터를 start=초 로 변환
  function parseStartSeconds(searchParams) {
    // 우선순위: start > t
    if (searchParams.has('start')) {
      const s = parseInt(searchParams.get('start'), 10);
      return Number.isFinite(s) ? s : 0;
    }
    if (searchParams.has('t')) {
      const t = searchParams.get('t');
      // 예: 90, 1m30s, 2m, 45s
      const sec = /^(\d+)$/.test(t)
        ? parseInt(t, 10)
        : (function () {
            let total = 0;
            const m = /(\d+)m/.exec(t);
            const s = /(\d+)s/.exec(t);
            if (m) total += parseInt(m[1], 10) * 60;
            if (s) total += parseInt(s[1], 10);
            return total || 0;
          })();
      return Number.isFinite(sec) ? sec : 0;
    }
    return 0;
  }

  // 임베드 DOM 생성
  function createEmbed(videoId, startSec) {
    const wrap = document.createElement('div');
    wrap.className = 'video-wrapper';

    const src = new URL(`https://www.youtube.com/embed/${videoId}`);
    src.searchParams.set('rel', '0');
    if (startSec > 0) src.searchParams.set('start', String(startSec));

    const iframe = document.createElement('iframe');
    iframe.src = src.toString();
    iframe.title = 'YouTube video';
    iframe.allow = 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share';
    iframe.setAttribute('allowfullscreen', '');

    wrap.appendChild(iframe);
    return wrap;
  }

  // a 태그(자동 링크)를 임베드로 교체
  function transformAnchor(a) {
    if (isInsideCode(a)) return;

    const href = a.getAttribute('href') || '';
    let match, videoId = null, tail = '';

    for (const re of YT_PATTERNS) {
      match = href.match(re);
      if (match) {
        videoId = match[1];
        tail = match[2] || '';
        break;
      }
    }
    if (!videoId) return;

    // 시작 시간 추출
    const urlObj = new URL(href);
    const startSec = parseStartSeconds(urlObj.searchParams);

    const embed = createEmbed(videoId, startSec);
    a.replaceWith(embed);
  }

  // 텍스트 노드에 맨몸 URL이 남아있는 경우(마크다운이 a로 바꾸지 않았을 때) 처리
  function transformBareUrls(root) {
    const walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT);
    const nodesToReplace = [];

    while (walker.nextNode()) {
      const node = walker.currentNode;
      if (!node.nodeValue) continue;
      if (isInsideCode(node.parentElement)) continue;

      const text = node.nodeValue;
      // URL 탐지
      const re = /(https?:\/\/[^\s<>"']+)/g;
      let m, lastIndex = 0, parts = [];

      while ((m = re.exec(text)) !== null) {
        parts.push(document.createTextNode(text.slice(lastIndex, m.index)));
        const url = m[1];

        let videoId = null, tail = '';
        for (const yt of YT_PATTERNS) {
          const got = url.match(yt);
          if (got) { videoId = got[1]; tail = got[2] || ''; break; }
        }

        if (videoId) {
          const urlObj = new URL(url);
          const startSec = parseStartSeconds(urlObj.searchParams);
          parts.push(createEmbed(videoId, startSec));
        } else {
          // 그냥 링크로 유지
          const a = document.createElement('a');
          a.href = url;
          a.textContent = url;
          a.rel = 'nofollow noopener';
          a.target = '_blank';
          parts.push(a);
        }
        lastIndex = re.lastIndex;
      }

      if (parts.length) {
        parts.push(document.createTextNode(text.slice(lastIndex)));
        nodesToReplace.push({ node, parts });
      }
    }

    for (const { node, parts } of nodesToReplace) {
      const frag = document.createDocumentFragment();
      parts.forEach(p => frag.appendChild(p));
      node.parentNode.replaceChild(frag, node);
    }
  }

  function run() {
    const roots = CONTAINERS
      .map(sel => document.querySelector(sel))
      .filter(Boolean);

    if (roots.length === 0) return;

    for (const root of roots) {
      // 1) a[href=유튜브] → iframe
      root.querySelectorAll('a[href*="youtu"]').forEach(transformAnchor);
      // 2) 텍스트로 남은 맨몸 URL → iframe
      transformBareUrls(root);
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', run);
  } else {
    run();
  }
})();
