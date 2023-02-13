function filter_by_currency() {
	flags = {}
	flags['AUD'] = getFlag('filter_aud')
	flags['CAD'] = getFlag('filter_cad')
	flags['GBP'] = getFlag('filter_gbp')
	flags['NIS'] = getFlag('filter_nis')
	flags['USD'] = getFlag('filter_usd')
	
	currency_cols = document.querySelectorAll("div[tag='column_currency']");
	for (let ii = 0; ii < currency_cols.length; ii++) {
		elem = currency_cols[ii]
		val = elem.innerText.trimStart().trimEnd().trimEnd()
		row = elem.closest('tr')
		if (flags[val]) {
			row.classList.remove('hidden')
		} else {
  			row.classList.add('hidden');
		}
	}
}

function getFlag(id) {
	elem = document.getElementById(id)
	return elem.checked
}