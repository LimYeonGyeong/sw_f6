<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Sign Up</title></head>
<body>
<h2>회원가입</h2>

<form method="post" action="signupProcess.jsp">
  아이디: <input type="text" name="user_id" required><br>
  비밀번호: <input type="password" name="password" required><br>
  이름: <input type="text" name="name" required><br>
  <button type="submit">가입</button>
</form>

<br>
<a href="login.jsp">로그인으로</a>
</body>
</html>
