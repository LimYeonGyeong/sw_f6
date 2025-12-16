<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="thinkonweb.util.ConnectionContext,java.sql.*" %>
<html><body>
<h2>영화 목록</h2>
<ul>
<%
String sql = "SELECT movie_id, title FROM movie ORDER BY title";
try (Connection conn = ConnectionContext.getConnection();
     PreparedStatement ps = conn.prepareStatement(sql);
     ResultSet rs = ps.executeQuery()) {
  while (rs.next()) {
    int id = rs.getInt("movie_id");
    String title = rs.getString("title");
%>
  <li><%= id %> — <%= title %></li>
<%
  }
}
%>
</ul>
</body></html>
