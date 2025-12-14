<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, thinkonweb.util.ConnectionContext" %>
<%@ page import="bean.Member" %>

<jsp:useBean id="member" class="bean.Member" scope="request" />
<jsp:setProperty name="member" property="id" param="user_id"/>
<jsp:setProperty name="member" property="password" param="password"/>
<jsp:setProperty name="member" property="name" param="name"/>

<%
request.setCharacterEncoding("UTF-8");

String checkSql  = "SELECT 1 FROM users WHERE user_id=?";
String insertSql = "INSERT INTO users(user_id, password, name) VALUES(?,?,?)";

try (Connection conn = ConnectionContext.getConnection()) {

    // 1) 중복 체크
    try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
        ps.setString(1, member.getId());
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
%>
<script>alert("이미 존재하는 아이디입니다."); history.back();</script>
<%
                return;
            }
        }
    }

    // 2) 가입
    try (PreparedStatement ps2 = conn.prepareStatement(insertSql)) {
        ps2.setString(1, member.getId());
        ps2.setString(2, member.getPassword()); 
        ps2.setString(3, member.getName());
        ps2.executeUpdate();
    }
%>
<script>alert("회원가입 완료! 로그인 해주세요."); location.href="login.jsp";</script>
<%
} catch (Exception e) {
%>
<script>alert("회원가입 처리 중 오류가 발생했습니다."); history.back();</script>
<%
}
%>
