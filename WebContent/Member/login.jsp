<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Login</title></head>
<body>
<h2>로그인</h2>

<form method="post" action="loginProcess.jsp">
  아이디: <input type="text" name="user_id" required><br>
  비밀번호: <input type="password" name="password" required><br>
  <button type="submit">로그인</button>
</form>

<hr>
<a href="signup.jsp">회원가입</a> |
<a href="findID.jsp">아이디 찾기</a> |
<a href="findPW.jsp">비밀번호 재설정</a>
</body>
</html>
