# Globals
api_key = '7c0a5517c60b6e558209d52eaf618ad3'
TMDb_url = 'https://api.themoviedb.org/3/'

# Loops through inputs and label names, then performs search request for details & adds watched movies to localStorage
listMovies = () ->
	movies = document.getElementsByTagName('label')
	inputs = document.getElementsByTagName('input')
	for movie in movies
		movie.addEventListener('click', (event) ->
			event.preventDefault()
			searchTMDb(event.target.innerHTML)
		)
	for input in inputs
		if localStorage.getItem(input.name)
			document.getElementById(input.name).parentElement.classList.add('watched')
			document.getElementById(input.name).setAttribute('checked', 'checked')
		input.addEventListener('click', (event) ->
			if event.target.checked
				localStorage.setItem(event.target.name, 'watched')
				event.target.parentElement.classList.add('watched')
			else
				localStorage.removeItem(event.target.name)
				event.target.parentElement.classList.remove('watched')
		)

# Search The Movie Database - https://www.themoviedb.org/
searchTMDb = (query) ->
	xhr = new XMLHttpRequest()
	request_url = TMDb_url + 'search/movie?api_key=' + api_key + '&query=' + query
	overlay = document.getElementById('overlay')
	panel = document.getElementById('panel')
	title = document.getElementById('title')
	detail = document.getElementById('details')
	rating = document.getElementById('rating')
	date = document.getElementById('date')
	poster = document.getElementById('poster')

	xhr.open('GET', request_url, true)
	xhr.onreadystatechange = () ->
		if (xhr.readyState == 4 && xhr.status == 200)
			results = JSON.parse(xhr.responseText).results
			if results[0]
				# Append title, details, rating, and date
				title.innerHTML = '<a href="https://themoviedb.org/movie/' + results[0].id + '" target="_blank">' + results[0].original_title + '</a>'
				detail.innerHTML = results[0].overview
				rating.innerHTML = results[0].vote_average
				# Format date properly
				release_date = new Date(results[0].release_date)
				monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"]
				date.innerHTML = monthNames[release_date.getMonth()] + ' ' + release_date.getDate() + ', ' + release_date.getFullYear()
				# Append poster
				poster.src = 'https://image.tmdb.org/t/p/w500/' + results[0].poster_path
				# Background image
				panel.style.backgroundImage = 'url("https://image.tmdb.org/t/p/w1280/' + results[0].backdrop_path + '")'
				# Toggles overlay open
				overlay.classList.add('open')
				console.log(results[0])
			else
				title.innerHTML = query
				detail.innerHTML = 'No results&hellip;'
				rating.innerHTML = ''
				date.innerHTML = ''
				poster.src = ''
				overlay.classList.add('open')
			# Bind click event to close overlay
			overlay.addEventListener('click', (event) ->
				overlay.classList.remove('open')
			)
	xhr.send(null)

listMovies()
