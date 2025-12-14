<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Reset Password</title></head>
<body>
<h2>비밀번호 재설정</h2>

<form method="post" action="findPWProcess.jsp">
  아이디: <input type="text" name="user_id" required><br>
  이름: <input type="text" name="name" required><br>
  새 비밀번호: <input type="password" name="new_password" required><br>
  <button type="submit">변경</button>
</form>

<br>
<a href="login.jsp">로그인으로</a>
</body>
</html>
