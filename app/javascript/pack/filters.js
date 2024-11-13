function apply_filter() {
	const flags = {}
	flags['AUD'] = getFlag('filter_aud')
	flags['CAD'] = getFlag('filter_cad')
	flags['GBP'] = getFlag('filter_gbp')
	flags['NIS'] = getFlag('filter_nis')
	flags['USD'] = getFlag('filter_usd')
	
	const currency_cols = document.querySelectorAll("div[tag='column_currency']");
	for (let ii = 0; ii < currency_cols.length; ii++) {
		const elem = currency_cols[ii]
		const val = elem.innerText.trimStart().trimEnd().trimEnd()
		const row = elem.closest('tr')
		// first filter, make everything visible first
		row.classList.remove('hidden')
		if (!flags[val]) {
  			row.classList.add('hidden');
		}
	}
	
	const really_good_price = getFlag('filter_really_good_price')
	const good_price = getFlag('filter_good_price')
	const big_investment = getFlag('filter_big_investment')
	const under_performer = getFlag('filter_under_performer')
	const div_overdue = getFlag('filter_div_overdue')
	const no_div_last_year = getFlag('filter_no_div_last_year')
	const comments = getFlag('filter_comments')
	const badges_cols = document.querySelectorAll("td[tag='column_badges']");
	console.log('>>> badges_cols', badges_cols)
	for (let ii = 0; ii < badges_cols.length; ii++) {
		const elem = badges_cols[ii]
		const current_badges = convertBadgesString(elem.getAttribute('data_badges'))
		console.log('>>> ', elem, current_badges)
		let displayThis = false
		displayThis = displayThis || hasRelevantBadge(really_good_price, 'really_good_price', current_badges)
		displayThis = displayThis || hasRelevantBadge(big_investment, 'big_investment', current_badges)
		displayThis = displayThis || hasRelevantBadge(good_price, 'good_price', current_badges)
		displayThis = displayThis || hasRelevantBadge(under_performer, 'under_performer', current_badges)
		displayThis = displayThis || hasRelevantBadge(div_overdue, 'div_overdue', current_badges)
		displayThis = displayThis || hasRelevantBadge(no_div_last_year, 'no_div_last_year', current_badges)
		displayThis = displayThis || hasRelevantBadge(comments, 'comments', current_badges)
		if (!displayThis) {
			const row = elem.closest('tr')
  			row.classList.add('hidden');
		}
	}
}

function hasRelevantBadge(badgeIsRelevant, badge, currentBadges) {
	return badgeIsRelevant && currentBadges.includes(badge)
}

function convertBadgesString(inVal) {
	const parseThis = inVal.replace(/ /g,'').replace(/:/g,'').replace('[','').replace(']','')
	const ans = parseThis.split(',')
	return ans
}

function getFlag(id) {
	elem = document.getElementById(id)
	return elem.checked
}