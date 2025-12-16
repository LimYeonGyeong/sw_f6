<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Sign Up</title>
  <%@ include file="_memberHead.jspf" %>
</head>
<body>

<div class="member-page">
  <div class="member-card">
    <div class="member-card__header">
      <h1 class="member-title">회원가입</h1>
      <p class="member-subtitle">아이디/비밀번호/이름을 입력하세요.</p>
    </div>

    <div class="member-card__body">
      <form class="member-form" method="post" action="signupProcess.jsp">
        <div class="member-field">
          <label>아이디</label>
          <input class="member-input" type="text" name="user_id" required>
        </div>

        <div class="member-field">
          <label>비밀번호</label>
          <input class="member-input" type="password" name="password" id="pw" required>
        </div>

        <div class="member-field">
          <label>비밀번호 확인</label>
          <input class="member-input" type="password" id="pw2" required>
          <div id="pwMsg" style="margin-top:6px; font-size:12px; color:#dc2626;"></div>
        </div>

        <div class="member-field">
          <label>이름</label>
          <input class="member-input" type="text" name="name" required>
        </div>

        <button class="member-btn" type="submit">가입</button>

        <div class="member-links">
          <a href="login.jsp">로그인으로</a>
          <span></span>
          <span></span>
        </div>
      </form>
    </div>
  </div>
</div>

</body>
</html>
