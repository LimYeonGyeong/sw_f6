<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Find ID</title>
  <%@ include file="_memberHead.jspf" %>
</head>
<body>

<div class="member-page">
  <div class="member-card">
    <div class="member-card__header">
      <h1 class="member-title">아이디 찾기</h1>
      <p class="member-subtitle">이름을 입력하면 아이디를 확인할 수 있어요.</p>
    </div>

    <div class="member-card__body">
      <form class="member-form" method="post" action="findIDProcess.jsp">
        <div class="member-field">
          <label>이름</label>
          <input class="member-input" type="text" name="name" required>
        </div>

        <button class="member-btn" type="submit">찾기</button>

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
