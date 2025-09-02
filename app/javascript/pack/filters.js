const badgeFilterParams = {
	badge_filter_r_good_price: 'really_good_price',
	badge_filter_r_good_price_OR_good_price: ['really_good_price', 'good_price'],
	badge_filter_big_investment: 'big_investment',
	badge_filter_under_prf_: 'under_performer',
	badge_filter_div_overdue: 'div_overdue',
	badge_filter_no_div_last_year: 'no_div_last_year',
	badge_filter_div_up_a_lot: 'div_up_25',
	badge_filter_div_up_a_lot_OR_div_up: ['div_up_25', 'div_up'],
	badge_filter_div_down_a_lot: 'div_down_25',
	badge_filter_div_down_a_lot_OR_div_down: ['div_down_25', 'div_down'],
	badge_filter_comments: 'comments',
}

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
	
	const filters = getBadgeFilters();
	console.log(filters);
	const badges_cols = document.querySelectorAll("td[tag='column_badges']");
	for (let ii = 0; ii < badges_cols.length; ii++) {
		const elem = badges_cols[ii]
		const current_badges = convertBadgesString(elem.getAttribute('data_badges'))
        console.log('>>> ------------------------------------------')
		if (badgeFilterMethodsSayHide(filters, current_badges)) {
			const row = elem.closest('tr')
  			row.classList.add('hidden');
  		}
	}
	recolourRows('indexRow')
}

function getBadgeFilters() {
  const result = {};
  const filters = document.querySelectorAll('.badge_filter');

  filters.forEach(filter => {
    const filterId = filter.id; // e.g. "badge_filter_Red_OR_Blue"
    const selected = filter.querySelector('input[type="radio"]:checked');
    result[filterId] = selected ? selected.value : null;
  });

  return result;
}

function badgeFilterMethodsSayHide(filters, current_badges) {
  console.log('>>> entered badgeFilterMethodsSayHide', filters, current_badges)
  for (const [badgeFilterName, value] of Object.entries(filters)) {
	console.log('>>> badgeFilterName, Value', badgeFilterName, value)
	if (value === 'Anything') {
		continue;
	}
	console.log('>>> gogin to params')
	const lookingFor = badgeFilterParams[badgeFilterName]
	console.log*('>>> badgeFilterName, lookingFor', badgeFilterName, lookingFor)
	const contains = calculateBadgesContains(lookingFor, current_badges)
	console.log('>>> contains = ', contains)
	const needsToHide = value === 'Must Be' ? !contains : contains
	if (needsToHide) {
		return true
	}
  }
  console.log('>>> ==========================================')
  return false
}

function calculateBadgesContains(lookingFor, current_badges) {
	console.log('>>> calculateBdgesContains: looking for', lookingFor)
	if (Array.isArray(lookingFor)) {
		console.log('>>> lookingFor is Array')
		let contains = false
		for (const lookingForOne of lookingFor) {
			contains = contains || current_badges.includes(lookingForOne)
		}
		return contains
	} else {
		console.log('>>> lookingFor is not Array')
		return current_badges.includes(lookingFor)
	}
}

function recolourRows(rowClass) {
	const rows = document.querySelectorAll(`tr.${rowClass}`);
	var toggle = true
    for (let ii = 0; ii < rows.length; ii++) {
        const row = rows[ii];
        if (!row.classList.contains('hidden')) {
	        row.classList.remove('rowcol_1', 'rowcol_2');
        
        	toggle = !toggle
        	if (toggle) {
            	row.classList.add('rowcol_1');
        	} else {
            	row.classList.add('rowcol_2');
        	}
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