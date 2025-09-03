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

function apply_filter() {
	const currencyFlags = {}
	const flag_style = document.getElementById('actions_filter').dataset.rowFlagFilterVal;

	currencyFlags['AUD'] = getFlag('filter_aud')
	currencyFlags['CAD'] = getFlag('filter_cad')
	currencyFlags['GBP'] = getFlag('filter_gbp')
	currencyFlags['NIS'] = getFlag('filter_nis')
	currencyFlags['USD'] = getFlag('filter_usd')
	
	const currency_cols = document.querySelectorAll("div[tag='column_currency']");
	const holdings_cols = document.querySelectorAll("td[tag='holdings']");
	const badges_cols = document.querySelectorAll("td[tag='column_badges']");
	const rowFlags = document.querySelectorAll("input[tag='row_flag']");
	
	const zero_holdings = getFlag('zero_holdings')
	const non_zero_holdings = getFlag('non_zero_holdings')
	const badgeFilters = getBadgeFilters();
	
	
	for (let ii = 0; ii < currency_cols.length; ii++) {
		let hideThis = false
		hideThis = applyCurrencyFilter(hideThis, ii, currency_cols, currencyFlags)
		hideThis = applyRowFlagFilter(hideThis, ii, rowFlags, flag_style)
		hideThis = applyHoldingsFilter(hideThis, ii, holdings_cols, zero_holdings, non_zero_holdings)
		hideThis = applyBadgesFilter(hideThis, ii, badges_cols, badgeFilters)
		
		const elem = currency_cols[ii]
		const row = elem.closest('tr')
		if (hideThis) {
  			row.classList.add('hidden');
		} else {
			row.classList.remove('hidden')
		}
	}
}
	
function applyCurrencyFilter(hideThis, ii, currency_cols, currencyFlags) {
	const elem = currency_cols[ii]
	const val = elem.innerText.trimStart().trimEnd().trimEnd()
	if (!currencyFlags[val]) {
  		hideThis = true
	}
	return hideThis
}
	
function applyRowFlagFilter(hideThis, ii, rowFlags, flag_style) {
	if (flag_style !== 'all') {
		const elem = rowFlags[ii]
		if (elem.checked === (flag_style === 'unflagged'))	 {
  			hideThis = true
  		}
	}
	return hideThis
}
	
function applyHoldingsFilter(hideThis, ii, holdings_cols, zero_holdings, non_zero_holdings) {
	const elem = holdings_cols[ii]
	if (!matches_holdings_filters(elem.innerText.trim(), zero_holdings, non_zero_holdings)) {
		hideThis = true
	}
	return hideThis
}
	
function applyBadgesFilter(hideThis, ii, badges_cols, badgeFilters) {
	const elem = badges_cols[ii]
	const current_badges = convertBadgesString(elem.getAttribute('data_badges'))
	if (badgeFilterMethodsSayHide(badgeFilters, current_badges)) {
		hideThis = true
	}
	return hideThis
}

function getBadgeFilters() {
  const result = {};
  const badgeFilters = document.querySelectorAll('.badge_filter');

  badgeFilters.forEach(filter => {
    const filterId = filter.id; // e.g. "badge_filter_Red_OR_Blue"
    const selected = filter.querySelector('input[type="radio"]:checked');
    result[filterId] = selected ? selected.value : null;
  });

  return result;
}

function badgeFilterMethodsSayHide(badgeFilters, current_badges) {
  for (const [badgeFilterName, value] of Object.entries(badgeFilters)) {
	if (value === 'Anything') {
		continue;
	}
	const lookingFor = badgeFilterParams[badgeFilterName]
	const contains = calculateBadgesContains(lookingFor, current_badges)
	const needsToHide = value === 'Must Be' ? !contains : contains
	if (needsToHide) {
		return true
	}
  }
  return false
}

function calculateBadgesContains(lookingFor, current_badges) {
	if (Array.isArray(lookingFor)) {
		let contains = false
		for (const lookingForOne of lookingFor) {
			contains = contains || current_badges.includes(lookingForOne)
		}
		return contains
	} else {
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