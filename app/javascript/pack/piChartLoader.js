document.addEventListener("DOMContentLoaded", () => {
  // Find all containers marked for pie charts
  document.querySelectorAll('[data-pie-chart]').forEach(container => {
    const canvas = container.querySelector("canvas");
    if (!canvas) return;

    // Find the nearest previous table
    const table = container.previousElementSibling;
    if (!table || table.tagName.toLowerCase() !== "table") return;

    const rows = Array.from(table.querySelectorAll("tbody tr.include_in_pi"));
    if (rows.length === 0) return;

    // Skip the header row
    // Skip the last row (assumed to be total)
    const dataRows = rows // ###.slice(1, -1);

    // Extract data
    const counts = {};
    dataRows.forEach(row => {
      const cells = row.querySelectorAll("td");
      if (cells.length === 0) return;

      const label = cells[0].innerText.trim();                   // first column as label
      const valueString = cells[cells.length - 1].innerText.trim().replace(/,/g, '');
      const value = parseFloat(valueString) || 0; // last column as value

      counts[label] = (counts[label] || 0) + value;
    });

    // Build Chart.js pie chart
    new Chart(canvas.getContext("2d"), {
      type: "pie",
      data: {
        labels: Object.keys(counts),
        datasets: [{
          data: Object.values(counts),
          backgroundColor: [
            "#4caf50", // green
            "#ff9800", // orange
            "#f44336", // red
            "#2196f3", // blue
            "#9c27b0", // purple
            "#ff5722", // deep orange
             "#03a9f4", // light blue
             "#8bc34a", // lime green
             "#ffc107", // amber
             "#e91e63", // pink
             "#9e9e9e", // grey
             "#673ab7"  // deep purple
          ]
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            position: "bottom",
            boxWidth: 30,
            font: {
                size: 12
            }
          }
        }
      }
    });
  });
});
