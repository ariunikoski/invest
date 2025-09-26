
// app/javascript/application.js

document.addEventListener("DOMContentLoaded", () => {
  const tz = Intl.DateTimeFormat().resolvedOptions().timeZone;

  // Only send if session doesn't already match
  if (tz && (!window.sessionStorage.getItem("sent_tz") || window.sessionStorage.getItem("sent_tz") !== tz)) {
    fetch("/set_timezone", {
      method: "POST",
      headers: { 
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ time_zone: tz })
    }).then(() => {
      window.sessionStorage.setItem("sent_tz", tz);
    });
  }
});
