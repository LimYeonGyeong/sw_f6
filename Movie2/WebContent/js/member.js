document.addEventListener("DOMContentLoaded", () => {
  const pw = document.querySelector("#pw");
  const pw2 = document.querySelector("#pw2");
  const msg = document.querySelector("#pwMsg");

  if (pw && pw2) {
    const check = () => {
      if (!pw2.value) {
        if (msg) msg.textContent = "";
        pw2.setCustomValidity("");
        return;
      }
      if (pw.value !== pw2.value) {
        if (msg) msg.textContent = "비밀번호가 서로 다릅니다.";
        pw2.setCustomValidity("비밀번호가 서로 다릅니다.");
      } else {
        if (msg) msg.textContent = "";
        pw2.setCustomValidity("");
      }
    };
    pw.addEventListener("input", check);
    pw2.addEventListener("input", check);
  }
});
