<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  String ctx = request.getContextPath();
  String loginUserId = (String) session.getAttribute("loginUserId");
  boolean isLogin = (loginUserId != null && !loginUserId.trim().isEmpty());
%>
<style>
  .navbar{
  display:flex;
  justify-content:space-between;
  align-items:center;
  padding:10px 20px;
  border-bottom:1px solid #ddd;
  background:#fff;
}

.home img{ height:50px; }

.right{ position:relative; }

.login-btn{
  padding:16px 28px;
  cursor:pointer;
}

.profile-img{
  width:50px;
  height:50px;
  border-radius:50%;
  cursor:pointer;
}

.dropdown{
  display:none;
  position:absolute;
  top:52px;
  right:0;
  width:150px;
  background:#fff;
  border:1px solid #ccc;
  border-radius:8px;
  overflow:hidden;
}

.dropdown.show{ display:block; }

.dropdown a{
  display:block;
  padding:10px 12px;
  text-align:center;
  text-decoration:none;
  color:#000;
}

.dropdown a:hover{ background:#f5f5f5; }

.dropdown .logout{
  background:red;
  color:#fff;
}

.dropdown .logout:hover{ background:darkred; }
</style>


<div class="navbar">
  <!-- 왼쪽 상단: 홈 -->
  <a class="home" href="<%=ctx%>/sw_f6/WebContent/home/home.jsp">
    <img src="<%=ctx%>/sw_f6/WebContent/media/home.png" alt="home">
  </a>

  <!-- 오른쪽 상단 -->
  <div class="right">
    <% if (!isLogin) { %>
      <button class="login-btn" type="button" onclick="location.href='<%=ctx%>/sw_f6/WebContent/Member/login.jsp'">로그인</button>
    <% } else { %>
      <img id="profileBtn" class="profile-img" src="<%=ctx%>/sw_f6/WebContent/media/user.png" alt="user">

      <div id="profileDropdown" class="dropdown">
        <a href="<%=ctx%>/sw_f6/WebContent/Member/MyPage.jsp">마이페이지</a>
        <a class="logout" href="<%=ctx%>/sw_f6/WebContent/Member/logout.jsp">로그아웃</a>
      </div>
    <% } %>
  </div>
</div>

<script>
  const btn = document.getElementById("profileBtn");
  const dd  = document.getElementById("profileDropdown");

  if (btn && dd) {
    btn.addEventListener("click", (e) => {
      e.stopPropagation();
      dd.classList.toggle("show");
    });

    window.addEventListener("click", () => {
      dd.classList.remove("show");
    });
  }
</script>
