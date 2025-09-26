
// app/javascript/application.js

alert(">>> adding event listener")
document.addEventListener("DOMContentLoaded", () => {
  alert(">>> listener called")
  const tz = Intl.DateTimeFormat().resolvedOptions().timeZone;

  // Only send if session doesn't already match
  if (tz && (!window.sessionStorage.getItem("sent_tz") || window.sessionStorage.getItem("sent_tz") !== tz)) {
    alert(">>> sending it")
    fetch("/set_timezone", {
      method: "POST",
      headers: { 
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ time_zone: tz })
    }).then(() => {
        alert(">>> zoom gully gully")
      window.sessionStorage.setItem("sent_tz", tz);
    });
  }
});
