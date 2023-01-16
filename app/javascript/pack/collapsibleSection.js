function toggleSection(elem, makeVisible) {
	console.log('>>> entered', elem, makeVisible)
	const collapsible = elem.parentElement.parentElement
	console.log('>>> collapsible', collapsible)
	const collapsibleIndex = Array.prototype.indexOf.call(collapsible.parentElement.children, collapsible);
	console.log('>>> collapsibleIndex', collapsibleIndex)
	const shareIndex = collapsible.parentElement.children[collapsibleIndex + 1]
	console.log('>>> chareIndex', shareIndex)
	if (makeVisible) {
		shareIndex.classList.remove('hidden')
	} else {
		shareIndex.classList.add('hidden')
	}
	
	let otherImage = elem.nextElementSibling
	if (!otherImage) {
		console.log(">>> trying again")
		otherImage = elem.previousElementSibling
	}
	console.log(">>> otherImage", otherImage)
	elem.classList.add("hidden")
	otherImage.classList.remove("hidden")
}