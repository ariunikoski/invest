sortDirections = [] 

function sortTable(evt, elem) {
  const table = getTable(elem)
  const colIndex = getColumnIndex(elem)
  const tbody = table.tBodies[0];
  const rows = Array.from(tbody.rows);

  if (evt.target !== evt.currentTarget) {
    // Only fires if the TH itself was clicked
    return
  }
  // toggle direction: asc / desc
  sortDirections[colIndex] = !(sortDirections[colIndex] ?? false);
  const asc = sortDirections[colIndex];

  rows.sort((a, b) => {
    let A = a.cells[colIndex].innerText.trim();
    let B = b.cells[colIndex].innerText.trim();

    // detect numbers
    const numA = parseFloat(removeCommas(A));
    const numB = parseFloat(removeCommas(B));
    if (!isNaN(numA) && !isNaN(numB)) {
      A = numA;
      B = numB;
    }

    if (A < B) return asc ? -1 : 1;
    if (A > B) return asc ? 1 : -1;
    return 0;
  });

  // reattach rows in new order
  rows.forEach(row => tbody.appendChild(row));
  
  // update indicators
  getHeaders(elem).forEach((hh, i) => {
	firstSpan = hh.querySelector("span")
	if (!firstSpan) {
		firstSpan = hh
	}
    firstSpan.textContent = firstSpan.textContent.replace(/[↑↓]$/, ""); // remove old indicator
    if (i === colIndex) {
      firstSpan.textContent += asc ? " ↑" : " ↓";
    }
  });
}

function removeCommas(fromThis){
	return fromThis.replace(/,/g, "");
}

function getTable(th) {
  if (!th) return null; // safety check
  return th.closest("table");
}

function getHeaders(th) {
  if (!th) return []; // safety check
  const row = th.parentElement;      // the <tr> containing the <th>
  return Array.from(row.children); // all <th> or <td> in that row
}

function getColumnIndex(th) {
  const cells = getHeaders(th)
  return cells.indexOf(th);
}
