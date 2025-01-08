function apply_filter(flag_style='all') {
	const flags = {}
	flags['AUD'] = getFlag('filter_aud')
	flags['CAD'] = getFlag('filter_cad')
	flags['GBP'] = getFlag('filter_gbp')
	flags['NIS'] = getFlag('filter_nis')
	flags['USD'] = getFlag('filter_usd')
	
	// filter by currency_cols must be first as it turns everyone on
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
	
	if (flag_style !== 'all') {
		const flags = document.querySelectorAll("input[tag='row_flag']");
		for (let ii = 0; ii < flags.length; ii++) {
			const elem = flags[ii]
			const row = elem.closest('tr')
			if (elem.checked === (flag_style === 'unflagged'))	 {
  				row.classList.add('hidden');
			}
		}
	}
	
	const zero_holdings = getFlag('zero_holdings')
	const non_zero_holdings = getFlag('non_zero_holdings')
	
	const really_good_price = getFlag('filter_really_good_price')
	const good_price = getFlag('filter_good_price')
	const big_investment = getFlag('filter_big_investment')
	const under_performer = getFlag('filter_under_performer')
	const div_overdue = getFlag('filter_div_overdue')
	const no_div_last_year = getFlag('filter_no_div_last_year')
	const comments = getFlag('filter_comments')
	
	const badges_cols = document.querySelectorAll("td[tag='column_badges']");
	const holdings_cols = document.querySelectorAll("td[tag='holdings']");
	for (let ii = 0; ii < badges_cols.length; ii++) {
		const elem = badges_cols[ii]
		const current_badges = convertBadgesString(elem.getAttribute('data_badges'))
		
		let displayThis = false
		if (matches_holdings_filters(holdings_cols[ii].innerText.trim(), zero_holdings, non_zero_holdings)) {
		  // i.e. dont check the badges if it already failed holdings
		  displayThis = displayThis || hasRelevantBadge(really_good_price, 'really_good_price', current_badges)
		  displayThis = displayThis || hasRelevantBadge(big_investment, 'big_investment', current_badges)
		  displayThis = displayThis || hasRelevantBadge(good_price, 'good_price', current_badges)
		  displayThis = displayThis || hasRelevantBadge(under_performer, 'under_performer', current_badges)
		  displayThis = displayThis || hasRelevantBadge(div_overdue, 'div_overdue', current_badges)
		  displayThis = displayThis || hasRelevantBadge(no_div_last_year, 'no_div_last_year', current_badges)
		  displayThis = displayThis || hasRelevantBadge(comments, 'comments', current_badges)
		}
		if (!displayThis) {
			const row = elem.closest('tr')
  			row.classList.add('hidden');
		}
	}
}

function matches_holdings_filters(holdings, zero_holdings, non_zero_holdings) {
	if (holdings === "0") {
		return zero_holdings
	} else {
		return non_zero_holdings
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