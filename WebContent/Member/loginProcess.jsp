<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, thinkonweb.util.ConnectionContext" %>
<%@ page import="bean.Member" %>

<jsp:useBean id="member" class="bean.Member" scope="request" />
<jsp:setProperty name="member" property="id" param="user_id"/>
<jsp:setProperty name="member" property="password" param="password"/>

<%
request.setCharacterEncoding("UTF-8");

String sql = "SELECT name FROM users WHERE user_id=? AND password=?";

try (Connection conn = ConnectionContext.getConnection();
     PreparedStatement ps = conn.prepareStatement(sql)) {

    ps.setString(1, member.getId());
    ps.setString(2, member.getPassword());

    try (ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            session.setAttribute("loginUserId", member.getId());
            session.setAttribute("loginUserName", rs.getString("name"));
            response.sendRedirect("../index.jsp");  // (수정해야함)메인 페이지 경로로 바꾸기
            return;
        }
    }
%>
<script>alert("아이디 또는 비밀번호가 올바르지 않습니다."); history.back();</script>
<%
} catch (Exception e) {
%>
<script>alert("로그인 처리 중 오류가 발생했습니다."); history.back();</script>
<%
}
%>
