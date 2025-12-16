<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../base.jsp" %>

<style>
  /* 카드 영역 전체를 아래로 내림 */
  .movie-section{
    margin-top: 120px; /* 더 내려오게 */
  }

  /* 4장 묶음(전체 폭 88%: 카드 19%*4 + 간격 4%*3 = 88%) */
  .movie-row{
    width: 88%;
    margin: 0 auto;             /* 중앙 배치 */
    display: flex;
    justify-content: space-between; /* 간격 강제 */
    gap: 4%;
  }

  .movie-card{
    width: 40%;
    position: relative;
    cursor: pointer;
  }

  /* ✅ 카드가 커진 만큼 세로도 자동으로 커지게 (비율 유지) */
  .movie-card img{
    width: 100%;
    aspect-ratio: 2 / 3;  /* 포스터 비율(가로:세로) */
    object-fit: cover;
    border-radius: 12px;
    display: block;
    border: 1px solid #ddd;
  }

  /* hover 오버레이 */
  .movie-info{
    position: absolute;
    inset: 0;
    background: rgba(0,0,0,0.75);
    color: #fff;
    padding: 14px;
    box-sizing: border-box;
    opacity: 0;
    transition: opacity 0.2s ease;
    border-radius: 12px;
  }
  .movie-card:hover .movie-info{ opacity: 1; }

  .movie-info h3{ margin: 0 0 8px; font-size: 16px; }
  .movie-info p{ margin: 4px 0; font-size: 13px; }

  /* 이미지가 없을 때도 카드가 커 보이도록(테스트용) */
  .poster-fallback{
    width: 100%;
    aspect-ratio: 2 / 3;
    border-radius: 12px;
    border: 1px solid #ddd;
    background: #f3f3f3;
    display:flex;
    align-items:center;
    justify-content:center;
    color:#666;
    font-size:14px;
  }

  .fixed-reserve-btn{
  position: fixed;
  right: 30px;
  bottom: 30px;
  padding: 14px 22px;
  border: none;
  border-radius: 30px;
  font-size: 25px;
  cursor: pointer;
  z-index: 1000;
}


</style>

<div class="movie-section">
  <button class="fixed-reserve-btn"
        onclick="location.href='<%=request.getContextPath()%>/sw_f6/WebContent/reserve/allMovieReserve.jsp'">
  예매하기
  </button>

  <div class="movie-row">

    <div class="movie-card" onclick="location.href='<%=request.getContextPath()%>/sw_f6/WebContent/reserve/movieDetail.jsp?movie_id=1'">

      <!-- ✅ 포스터가 없으면 아래 div로 바꿔 테스트 가능 -->
      <img src="<%=request.getContextPath()%>/media/sample1.jpg" alt="movie">
      <!-- <div class="poster-fallback">movie</div> -->
      <div class="movie-info">
        <h3>영화 제목 1</h3>
        <p>등급: 12세</p>
        <p>러닝타임: 120분</p>
        <p>줄거리: 샘플</p>
      </div>
    </div>

    <div class="movie-card" onclick="location.href='<%=request.getContextPath()%>/sw_f6/WebContent/reserve/movieDetail.jsp?movie_id=2'">
      <img src="<%=request.getContextPath()%>/media/sample2.jpg" alt="movie">
      <div class="movie-info">
        <h3>영화 제목 2</h3>
        <p>등급: 전체</p>
        <p>러닝타임: 98분</p>
        <p>줄거리: 샘플</p>
      </div>
    </div>

    <div class="movie-card" onclick="location.href='<%=request.getContextPath()%>/sw_f6/WebContent/reserve/movieDetail.jsp?movie_id=3'">
      <img src="<%=request.getContextPath()%>/media/sample3.jpg" alt="movie">
      <div class="movie-info">
        <h3>영화 제목 3</h3>
        <p>등급: 15세</p>
        <p>러닝타임: 110분</p>
        <p>줄거리: 샘플</p>
      </div>
    </div>

    <div class="movie-card" onclick="location.href='<%=request.getContextPath()%>/sw_f6/WebContent/reserve/movieDetail.jsp?movie_id=4'">
      <img src="<%=request.getContextPath()%>/media/sample4.jpg" alt="movie">
      <div class="movie-info">
        <h3>영화 제목 4</h3>
        <p>등급: 청불</p>
        <p>러닝타임: 130분</p>
        <p>줄거리: 샘플</p>
      </div>
    </div>

  </div>
</div>
