function sveltalize(text, base) {
	const paths = text.split('/')
	if (base && paths[0] !== base) {
		return text
	}
	const file = base ? paths[paths.length - 1] : paths
	const route = paths.slice(0, paths.length - 1).join('/') || '/'

	return route
}

console.log(sveltalize('/+page.svelte'))
