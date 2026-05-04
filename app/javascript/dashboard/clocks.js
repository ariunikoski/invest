(() => {
  let timer = null;

  function getTimeParts(tz) {
    const now = new Date();

    const parts = new Intl.DateTimeFormat("en-US", {
      timeZone: tz,
      hour: "2-digit",
      minute: "2-digit",
      hour12: false
    }).formatToParts(now);

    let hour = 0;
    let minute = 0;

    parts.forEach(p => {
      if (p.type === "hour") hour = parseInt(p.value, 10);
      if (p.type === "minute") minute = parseInt(p.value, 10);
    });

    return { hour, minute };
  }

  function updateClocks() {
    document.querySelectorAll(".clock-item").forEach(card => {
      const tz = card.dataset.tz;
      const { hour, minute } = getTimeParts(tz);

      // Analog rotation
      const hour12 = hour % 12;
      const hourDeg = (hour12 * 30) + (minute * 0.5);
      const minuteDeg = minute * 6;

      const hourHand = card.querySelector(".hour-hand");
      const minuteHand = card.querySelector(".minute-hand");

      if (hourHand) {
        hourHand.style.transform =
          `translateX(-50%) rotate(${hourDeg}deg)`;
      }

      if (minuteHand) {
        minuteHand.style.transform =
          `translateX(-50%) rotate(${minuteDeg}deg)`;
      }

      // Digital time (HH:MM, 24h)
      const hh = String(hour).padStart(2, "0");
      const mm = String(minute).padStart(2, "0");

      const timeLabel = card.querySelector(".time-label");
      if (timeLabel) {
        timeLabel.textContent = `${hh}:${mm}`;
      }

      // Day / night shading
      const isNight = (hour < 6 || hour >= 18);
      card.classList.toggle("night", isNight);
    });
  }

  function startClocks() {
    if (timer) clearInterval(timer);

    updateClocks();

    // update once per minute
    timer = setInterval(updateClocks, 60000);
  }

  document.addEventListener("DOMContentLoaded", startClocks);
  document.addEventListener("turbo:load", startClocks);
})();