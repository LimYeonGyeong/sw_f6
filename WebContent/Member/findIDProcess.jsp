<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, thinkonweb.util.ConnectionContext" %>

<%
request.setCharacterEncoding("UTF-8");
String name = request.getParameter("name");

String sql = "SELECT user_id FROM users WHERE name=?";
%>

<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Find ID Result</title></head>
<body>
<h2>아이디 찾기 결과</h2>

<%
try (Connection conn = ConnectionContext.getConnection();
     PreparedStatement ps = conn.prepareStatement(sql)) {

    ps.setString(1, name);

    boolean found = false;
    try (ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            found = true;
%>
<div>아이디: <b><%= rs.getString("user_id") %></b></div>
<%
        }
    }

    if (!found) {
%>
<div>해당 이름으로 가입된 아이디가 없습니다.</div>
<%
    }

} catch (Exception e) {
%>
<div>오류가 발생했습니다.</div>
<%
}
%>

<br><a href="login.jsp">로그인으로</a>
</body>
</html>
