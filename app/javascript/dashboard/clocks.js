(() => {
  let timeTimer = null;
  let rotateTimer = null;
  let currentIndex = 0;

  // EASY CONFIGURATION
  const ROTATION_INTERVAL = 4000; // ms (change this)
  const FADE_DURATION = 600;      // should match CSS transition

  const ISRAEL_TZ = "Asia/Jerusalem";

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

    function getTimezoneOffset(tz, date = new Date()) {
    const parts = new Intl.DateTimeFormat("en-US", {
      timeZone: tz,
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
      hour: "2-digit",
      minute: "2-digit",
      second: "2-digit",
      hour12: false
    }).formatToParts(date);

    const values = {};

    parts.forEach(p => {
      if (p.type !== "literal") {
        values[p.type] = parseInt(p.value, 10);
      }
    });

    const asUTC = Date.UTC(
      values.year,
      values.month - 1,
      values.day,
      values.hour,
      values.minute,
      values.second
    );

    return (asUTC - date.getTime()) / 60000;
  }

  function getIsraelDifference(tz) {
    const now = new Date();

    const cityOffset = getTimezoneOffset(tz, now);
    const israelOffset = getTimezoneOffset(ISRAEL_TZ, now);

    return cityOffset - israelOffset;
  }

  function formatDifference(minutes) {
    if (minutes === 0) {
      return "Same time";
    }

    const sign = minutes > 0 ? "+" : "-";
    const absoluteMinutes = Math.abs(minutes);

    const hours = Math.floor(absoluteMinutes / 60);
    const mins = absoluteMinutes % 60;

    if (mins === 0) {
      return `${sign}${hours}h`;
    }

    return `${sign}${hours}h ${mins}m`;
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

      // Difference from Israel
      const difference = getIsraelDifference(tz);

      const differenceLabel =
        card.querySelector(".difference-label");

      if (differenceLabel) {
        differenceLabel.textContent =
          formatDifference(difference);
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