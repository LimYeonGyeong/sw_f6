<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, thinkonweb.util.ConnectionContext" %>

<%
request.setCharacterEncoding("UTF-8");

String userId = request.getParameter("user_id");
String name = request.getParameter("name");
String newPw = request.getParameter("new_password");

String sql = "UPDATE users SET password=?, updated_at=CURRENT_TIMESTAMP WHERE user_id=? AND name=?";

try (Connection conn = ConnectionContext.getConnection();
     PreparedStatement ps = conn.prepareStatement(sql)) {

    ps.setString(1, newPw);
    ps.setString(2, userId);
    ps.setString(3, name);

    int updated = ps.executeUpdate(); // 1이면 성공, 0이면 불일치

    if (updated == 1) {
%>
<script>alert("비밀번호가 변경되었습니다. 다시 로그인해주세요."); location.href="login.jsp";</script>
<%
    } else {
%>
<script>alert("아이디/이름이 일치하지 않습니다."); history.back();</script>
<%
    }

} catch (Exception e) {
%>
<script>alert("비밀번호 변경 중 오류가 발생했습니다."); history.back();</script>
<%
}
%>
