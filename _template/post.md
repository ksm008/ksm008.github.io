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
tags:
---