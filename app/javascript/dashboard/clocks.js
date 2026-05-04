(() => {
  let timeTimer = null;
  let rotateTimer = null;
  let currentIndex = 0;

  // EASY CONFIGURATION
  const ROTATION_INTERVAL = 4000; // ms (change this)
  const FADE_DURATION = 600;      // should match CSS transition

  function getTimeParts(tz) {
    const now = new Date();

    const parts = new Intl.DateTimeFormat("en-US", {
      timeZone: tz,
      hour: "2-digit",
      minute: "2-digit",
      hour12: false
    }).formatToParts(now);

    let hour = 0, minute = 0;

    parts.forEach(p => {
      if (p.type === "hour") hour = parseInt(p.value, 10);
      if (p.type === "minute") minute = parseInt(p.value, 10);
    });

    return { hour, minute };
  }

  function updateTimes() {
    document.querySelectorAll(".clock-slide").forEach(card => {
      const tz = card.dataset.tz;
      const { hour, minute } = getTimeParts(tz);

      const isNight = (hour < 7 || hour >= 22);
      card.classList.toggle("night", isNight);

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

      const hh = String(hour).padStart(2, "0");
      const mm = String(minute).padStart(2, "0");

      const timeLabel = card.querySelector(".time-label");
      if (timeLabel) {
        timeLabel.textContent = `${hh}:${mm}`;
      }
    });
  }

  function rotateClocks() {
    const slides = document.querySelectorAll(".clock-slide");
    if (slides.length === 0) return;

    slides[currentIndex].classList.remove("active");

    currentIndex = (currentIndex + 1) % slides.length;

    slides[currentIndex].classList.add("active");
  }

  function start() {
    // avoid duplicates (Turbo-safe)
    if (timeTimer) clearInterval(timeTimer);
    if (rotateTimer) clearInterval(rotateTimer);

    updateTimes();

    // update every minute
    timeTimer = setInterval(updateTimes, 60000);

    // rotate clocks
    rotateTimer = setInterval(rotateClocks, ROTATION_INTERVAL);
  }

  document.addEventListener("DOMContentLoaded", start);
  document.addEventListener("turbo:load", start);
})();