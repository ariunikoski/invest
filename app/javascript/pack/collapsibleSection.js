function toggleSection(elem, makeVisible) {
	console.log('>>> entered', elem, makeVisible)
	const collapsible = elem.parentElement.parentElement
	console.log('>>> collapsible', collapsible)
	const collapsibleIndex = Array.prototype.indexOf.call(collapsible.parentElement.children, collapsible);
	console.log('>>> collapsibleIndex', collapsibleIndex)
	const shareIndex = collapsible.parentElement.children[collapsibleIndex + 1]
	console.log('>>> chareIndex', shareIndex)
	toggleNode(shareIndex, elem, makeVisible)
}

function toggleHiddenRow(elem, makeVisible, rowId) {
	const node = document.getElementById(rowId)
	toggleNode(node, elem, makeVisible)
}


function toggleNode(node, callingButton, makeVisible) {
	if (makeVisible) {
		node.classList.remove('hidden')
	} else {
		node.classList.add('hidden')
	}
	
	let otherImage = callingButton.nextElementSibling
	if (!otherImage) {
		otherImage = callingButton.previousElementSibling
	}
	callingButton.classList.add("hidden")
	otherImage.classList.remove("hidden")
}