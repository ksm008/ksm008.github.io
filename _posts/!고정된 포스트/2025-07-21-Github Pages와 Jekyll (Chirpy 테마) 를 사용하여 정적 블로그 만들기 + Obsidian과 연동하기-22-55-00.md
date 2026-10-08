---
layout: post
title: Github Pages와 Jekyll (Chirpy 테마) 를 사용하여 정적 블로그 만들기 + Obsidian과 연동하기
date: 2025-07-21 22:55:00 +0900
categories:
  - 개발 공부
  - 깃허브 블로그
tags:
  - 깃허브_페이지
  - Jekyll
published: true
pin: true
---
# 시작하기에 앞서
네이버, 티스토리부터 벨로그, 그리고 결국 직접 만드는 깃허브 블로그까지 오게 되었습니다. 

> 왜 굳이? 그냥 티스토리나 네이버 블로그 쓰면 되는거 아니야?

라는 질문에 대한 대답은...

<p align="center">"힙하니까"</p>

블로그를 바꾼 주 이유는 아니지만 '다른 블로그에 비해 힙하다' 라는 느낌이 어느정도 지분이 있긴 합니다. 

주 이유는 **마크다운을 지원하는 블로그**이기 때문입니다. 벨로그도 마크다운을 지원하는 곳이지만 커스터마이징이나 카테고리 세부분류 등 부족한 부분이 많았습니다. 단순하고 미니멀리즘을 추구하는 사람들에게는 벨로그가 더 어울릴테지만 저에게는 아니였으니깐요.

때문에 코드를 방식으로 직접 렌더링이 되는 깃허브 블로그를 선택하게 되었습니다. 옵시디언과 같이 쓰니까 그냥 블로그 글 쓰는거랑 느낌도 비슷해서 번거롭지도 않은 것 같고요. 

그래서 어떻게 페이지를 구성하는지 제가 아는 선에서 가이드를 작성해보려고 합니다. 물론 저도 모르는 게 많습니다. 똑같이 따라했는데 왜 안되냐고 화내지 않으셨으면 좋겠습니다.

계속해서 작성중입니다.

---
## 깃허브 페이지 + 지킬 (Chirpy 테마) 구성

### 초기 설치

필수로 설치해야 할 프로그램은 다음과 같습니다.

- [Git](https://git-scm.com/)
- [Ruby](https://rubyinstaller.org/) - With Devkit으로 설치

둘 다 설치하고, cmd를 열어 아래 명령어로 설치가 정상적으로 되었는지 확인해줍시다. 

```bash
git -v 
ruby -v
```

---
### 레포지토리 생성
![](assets/img/_blogImage/개발/기타/깃허브블로그/스크린샷%202025-07-23%20100534.png)
[Chirpy Starter](https://github.com/cotes2020/chirpy-starter)에 들어가서 Use this template 클릭하고 그리고 레포지토리 이름을 `깃허브아이디.github.io`로 생성해줍니다. (깃허브는 `자신의깃허브아이디.github.io`라는 이름의 레포지토리를 자동으로 인식해 페이지를 생성함).


![](assets/img/_blogImage/개발/기타/깃허브블로그/스크린샷%202025-07-23%20102941.png)
생성이 완료되었다면 로컬에 해당 레포지토리를 클론 후 `_config.yml`을 수정해야 합니다.  아래에 있는 부분들만 바꿔주시면 됩니다.

```yaml
# 페이지 언어 설정
lang: ko-KR

# 시간대 설정
timezone: Asia/Seoul

# 미래 시간대 게시글 허용
future: true

# 블로그 제목
title: 늙고 병든 공부방

# 블로그 부제
tagline: 여기저기 잔병 많은 사람의 노트 

# 블로그 링크
url: "https://ksm008.github.io/" 

# 깃허브 링크
github:
  username: username # 자신의 깃허브 아이디
```

기본적인 세팅은 이 정도하면 하면 되고, 자세한 건 해당 파일 안 주석을 참고하시면 될 것 같습니다. 

![](assets/img/_blogImage/개발/기타/깃허브블로그/화면%20캡처%202025-07-23%20095043.png)
Chirpy 테마는 파일 전체를 복사해서 적용하는 방식을 사용하므로 레포지토리의 설정을 바꿔주어야 합니다.  Settings - Pages 에서 Build and deployment의 Source를 Github Actions로 바꿔주어야 깃허브에서 페이지를 빌드하고 배포할 수 있습니다.

마지막으로 `_config.yml` 수정사항이 적용되도록 커밋 후 푸시해주면 됩니다. 

```bash
git add .
git commit -m "초기 구성"
git push orign main
```

![](assets/img/_blogImage/개발/기타/깃허브블로그/스크린샷%202025-07-23%20110354.png)

푸시를 하게 되면 깃허브 페이지에 액션이 취해집니다. 본인이 커밋하면서 썼던 코멘트 이름으로 액션이 취해지며, 여기서 자신의 페이지가 빌드/배포되었는지, 오류가 발생했다면 무슨 내용인지를 파악할 수 있습니다. 빌드와 배포가 문제 없이 진행되었다면 `깃허브아이디.github.io`로 들어가 페이지를 확인해보세요.

---
### 지킬의 특징
- **게시글은 모두 `_post`폴더** <br>지킬에서 게시글을 인식하려면 `_post`폴더에 파일이 존재해야 합니다. 게다가 파일의 이름은 `YYYY-MM-DD-제목` 형식을 띄어야 하고, 내부에는 Front-Matter가 적용되어 있어야 합니다. 그렇기 때문에 새 글을 작성할 때 매번 파일 이름을 바꾸고 Front-Matter를 삽입하려면 매우 귀찮을겁니다.. 이를 해결하기 위해 아래 [Templater 설정](#templater-설정)에서 `_post`폴더에 새로운 문서가 생성되면 이름을 입력받고 그 이름을 포맷에 맞게 변경하도록 설정할겁니다. <br>`_post` 폴더 안에 모든 게시글들을 분류 없이 넣어두면 추후 수정할 때 복잡할겁니다. 때문에`_post` 폴더 내부에 추가로 폴더를 만들고 그 안에 문서를 작성해도 글로 인식합니다. 하지만 폴더로 분류한다고 지킬이 글을 자동으로 분류시키지는 않습니다. 이는 카테고리를 따로 만들어야 합니다.
- **이미지는 모두 `assets/img` 폴더**<br> 이미지 폴더는 해당 경로가 기본 경로입니다. 사진을 붙여 넣을때는 해당 폴더에 이미지를 넣고, 마크다운 문서에 `![](이미지 링크)` 형식으로 넣어야 합니다 (옵시디언 문법`[[파일명]]`은 작동하지 않습니다). <br>이미지 폴더도 안에 추가로 폴더를 만들고 그 안에 이미지를 넣어도 인식합니다.

![](assets/img/_blogImage/Pasted%20image%2020261008173820.png)

노트와 이미지를 효율적으로 사용하기 위해서 설정해줘야 할 것들이 있습니다. 
- 새 노트를 생성하는 위치 : **아래에 지정된 폴더**
	- 새 노트가 생성되는 폴더 : `_post` 폴더로 설정. 해도 되고 안해도 됩니다.
- 새 첨부파일을 생성할 위치 : **아래에 지정된 폴더**
	- 첨부 파일 폴더 경로 : `assets/img` 폴더로 설정. 저의 경우 `raw.githubusercontent.com`를 사용하도록 설정해서 폴더가 다릅니다. 
- 새로 생성하는 링크 형식 : **보관함에서의 절대 경로**로 설정. 그래야 링크가 `![](/assets/image/파일명.jpg)` 같은 형태로 생성됩니다.
- 내부 링크를 자동 업데이트 : **True**
- 위키 링크 : **False**

---
### 커스터마이징

Chirpy 테마는 기본 Jekyll 보다 커스터마이징의 자유도가 높습니다. 
#### 프로필 사진과 아이콘 변경

![](assets/img/_blogImage/개발/기타/깃허브블로그/스크린샷%202025-07-23%20125051.png)

프로필 사진은 avatar.jpg / png로 이름 짓고 이미지 폴더에 넣어주시면 됩니다. 아이콘은 이미지 폴더 안에 favicons 폴더를 새로 만든 후, favicon.ico / favicon-32x32.png / favicon-16x16.png를 넣어주시면 됩니다.

---
#### 정보 페이지 수정

![](assets/img/_blogImage/개발/기타/깃허브블로그/스크린샷%202025-07-23%20130055.png)

`_tabs`폴더 안의` about.md` 파일을 수정하시면 됩니다.

---
#### include, layout, plugin폴더 사용
`_include`, `_layout`, `_plugin` 폴더에 커스텀 HTML과 루비 플러그인을 만들어서 블로그를 원하는 방식으로 고칠수도 있습니다.
include, layout 파일 확장자는 html, 플러그인의 경우 파일 확장자는 `.rb`입니다. 이름은 알아서 지으면 됩니다.

- **테이블 드래그바 제거**
![](assets/img/_blogImage/스크린샷%202026-10-08%20155111.png)

표 아래의 드래그바를 없애는 플러그인입니다.

```
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
```

![](assets/img/_blogImage/Pasted%20image%2020261008170334.png)

그러면 크기에 맞춰 자동으로 정렬됩니다.

---
- **수정 시각 표시**

```
#!/usr/bin/env ruby
#
# Check for changed posts

Jekyll::Hooks.register :posts, :post_init do |post|

  commit_num = `git rev-list --count HEAD "#{ post.path }"`

  if commit_num.to_i > 1
    lastmod_date = `git log -1 --pretty="%ad" --date=iso "#{ post.path }"`
    post.data['last_modified_at'] = lastmod_date
  end

end
```

Chirpy 테마는 마지막으로 수정된 날짜를 표시할 수 있으나 사용자가 일일이 수정해줘야 합니다. 그걸 자동화 시켜주는 플러그인입니다. 이 플러그인이 동작하기 위해서는 `/github/workflows/page-deploy.yml` 파일의 `fetch-depth` 값이 0이어야 합니다. 확인해보시고 1이면 0으로 바꿔주면 됩니다.

```
steps:
  - name: Checkout
    uses: actions/checkout@v4
    with:
      fetch-depth: 0
```

---
- **옵시디언 하이라이트 적용**

```
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
```

지킬 마크다운은 옵시디언의 ==🔴하이라이트를== 인식하지 못합니다. 때문에 옵시디언의 하이라이트를 사용한다면 이를 변환해주는 플러그인을 만들어야 합니다. CSS로 설정하려 했지만 CSS가 계속 무시되는 문제가 있어 루비 플러그인으로 바로 때려 박아주는게 좋은것 같습니다.

![](assets/img/_blogImage/Pasted%20image%2020261008172559.png)

하이라이트를 추가하면 이렇게 됩니다.

---
## 깃허브와 옵시디언 연동
저는 데스크톱이나 모바일에서 필기를 할 때는 옵시디언을 사용합니다. 구글 드라이브를 사용하여 간편하게 양쪽 환경에서도 쓸 수 있고, 마크다운 문서들이기 때문에 가독성도 좋습니다. Jekyll 역시 마크다운 문서를 쓰기 때문에 옵시디언을 여기에 사용할 수 있습니다.

### 사용할 커뮤니티 플러그인

![](assets/img/_blogImage/개발/기타/깃허브블로그/11112.png)

제가 사용하고 있는 플러그인들입니다. 많지는 않고 필요한 것들만 쓰는 중입니다. 

- **Git** <br> 깃허브에 자동 / 수동으로 커밋 + 푸시, 풀을 제공하는 플러그인입니다. 모바일도 가능하다곤 하지만 아직 시험적인것 같습니다.
- **Templater**<br> 템플릿을 자동으로 넣게 해주는 플러그인입니다. Jekyll의 경우 `_post`폴더 안에 있는 문서들 중 이름이 `YYYY-MM-DD-제목`과 같은 형태인 문서들만 글들로 불러옵니다. 그리고 속성도 들어가야 합니다. 때문에 `_post` 폴더에 새 문서를 작성하면 이름을 자동으로 바꾸고 속성을 주입하도록 설정해야 합니다.
- **Code Styler** <br> 코드의 가독성을 높여주는 플러그인입니다. 코드 블럭 안에 줄을 보이게 해줍니다. 블로그에는 영향을 주지 않습니다.
- **SortSpec**
	- 커스텀 정렬을 지원하는 플러그인입니다. 날짜 순서가 아닌 포스트의 제목으로 정렬이 가능하게 해줍니다.

---
### Git 설정
이 플러그인은 옵시디언 보관함에 있는 .git 폴더를 자동으로 인식해 사용자의 레포지토리를 인식합니다. 그래서 설정할 것은 별로 없습니다.

![](assets/img/_blogImage/개발/기타/깃허브블로그/스크린샷%202025-07-24%20154632.png)

저는 오토 커밋 주기를 5분으로, 파일 작성을 멈춘 후에만 커밋 시키도록 설정했습니다. 

---
### Templater 설정
이 플러그인으로 `_post` 폴더에 새로운 문서가 생성될 때마다 자동으로 제목을 입력받고 이름을 바꿀겁니다. 

먼저 로컬 프로젝트 폴더에 `_template` 같은 이름의 폴더를 하나 만들고, 안에 템플릿 마크다운 파일을 하나 생성해줍시다. 저는 `_template` 폴더 안에 post.md 파일을 하나 만들었습니다. 

만들어진 마크다운 파일 안에 아래 코드를 붙여 넣어주세요.

```markdown
<%*
  // 1) 제목을 물어보기
  const postTitle = await tp.system.prompt("포스트 제목을 입력하세요");
  // 2) 날짜/시간 스트링
  const date = tp.date.now("YYYY-MM-DD");
  const time = tp.date.now("HH-mm-ss");
  // 3) 파일명 리네임
  await tp.file.rename(`${date}-${postTitle}-${time}`);
%>---
layout: post
title: <% postTitle %>
date:  <% tp.date.now("YYYY-MM-DD HH:mm:ss ZZ") %> 
categories:
published: true
math: true
tags:
---
```

그리고 Templater 플러그인 설정에 들어가서 `_post` 폴더에 새로운 문서를 생성할 때 글 제목을 입력받아 즉시 변환하도록 하면 됩니다.

- published : 공개 / 비공개 설정입니다. 일단 작성하고 나중에 올리고 싶으면 체크 풀어두시면 됩니다.
- math : 블로그에서 수학 수식 사용을 가능하게 해줍니다.

![](assets/img/_blogImage/스크린샷%202026-10-08%20170550.png)


![](assets/img/_blogImage/스크린샷%202026-10-08%20170554.png)

![](assets/img/_blogImage/스크린샷%202026-10-08%20170605.png)

템플릿 폴더 경로를 아까 만든 템플릿 폴더를 선택해주세요. Trigger Templater on new file creation을 켜주시고, 아래에 있는 Folder templates에서 템플릿 파일이 들어있는 경로를 정해주시면 됩니다.

![](assets/img/_blogImage/개발/기타/깃허브블로그/스크린샷%202025-07-24%20155420.png)

그러면 이렇게 제목을 입력받을 수 있습니다.

![](assets/img/_blogImage/개발/기타/깃허브블로그/스크린샷%202025-07-24%20155459.png)

제목을 입력하고 나면 자동으로 Front-Matter가 적용되어 지킬에서 게시글로 인식합니다. 