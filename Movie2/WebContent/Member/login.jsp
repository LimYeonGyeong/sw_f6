<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Login</title>
  <%@ include file="_memberHead.jspf" %>
</head>
<body>

<div class="member-page">
  <div class="member-card">
    <div class="member-card__header">
      <h1 class="member-title">로그인</h1>
      <p class="member-subtitle">아이디와 비밀번호를 입력하세요.</p>
    </div>

    <div class="member-card__body">
      <form class="member-form" method="post" action="loginProcess.jsp">
        <div class="member-field">
          <label>아이디</label>
          <input class="member-input" type="text" name="user_id" required>
        </div>

        <div class="member-field">
          <label>비밀번호</label>
          <input class="member-input" type="password" name="password" required>
        </div>

        <button class="member-btn" type="submit">로그인</button>

        <div class="member-links">
          <a href="signup.jsp">회원가입</a>
          <a href="findID.jsp">아이디 찾기</a>
          <a href="findPW.jsp">비밀번호 재설정</a>
        </div>
      </form>
    </div>
  </div>
</div>

</body>
</html>
