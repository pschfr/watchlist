# Globals
api_key = '7c0a5517c60b6e558209d52eaf618ad3'
TMDb_url = 'https://api.themoviedb.org/3/'

# Loops through inputs and label names, then performs search request for details & adds watched movies to localStorage
listMovies = () ->
	for movie in document.getElementsByTagName('label')
		movie.addEventListener('click', (event) ->
			event.preventDefault()
			searchTMDb(event.target.innerHTML)
		)
	for input in document.getElementsByTagName('input')
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

	xhr.open('GET', request_url, true)
	xhr.onreadystatechange = () ->
		if (xhr.readyState == 4 && xhr.status == 200)
			results = JSON.parse(xhr.responseText).results
			if results[0]
				# Append title, details, rating, and date
				document.getElementById('title').innerHTML = '<a href="https://themoviedb.org/movie/' + results[0].id + '" target="_blank">' + results[0].original_title + '</a>'
				document.getElementById('details').innerHTML = results[0].overview
				document.getElementById('rating').innerHTML = results[0].vote_average
				# Format date properly
				release_date = new Date(results[0].release_date)
				monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"]
				document.getElementById('date').innerHTML = monthNames[release_date.getMonth()] + ' ' + release_date.getDate() + ', ' + release_date.getFullYear()
				# Append poster
				document.getElementById('poster').src = 'https://image.tmdb.org/t/p/w500/' + results[0].poster_path
				# Background image
				document.getElementById('panel').style.backgroundImage = 'url("https://image.tmdb.org/t/p/w1280/' + results[0].backdrop_path + '")'
				# Finds genre based on ID
				document.getElementById('genres').innerHTML = ''
				for genreID in results[0].genre_ids
					lookupGenre(genreID)
				# Toggles overlay open
				document.getElementById('overlay').classList.add('open')
			else
				document.getElementById('title').innerHTML = query
				document.getElementById('details').innerHTML = 'No results&hellip;'
				document.getElementById('rating').innerHTML = ''
				document.getElementById('date').innerHTML = ''
				document.getElementById('poster').src = ''
				document.getElementById('overlay').classList.add('open')
			# Bind click event to close overlay
			document.getElementById('overlay').addEventListener('click', (event) ->
				document.getElementById('overlay').classList.remove('open')
			)
	xhr.send(null)

# Stores all genres in localStorage for only one API call
findGenres = () ->
	xhr = new XMLHttpRequest()
	request_url = TMDb_url + 'genre/movie/list?api_key=' + api_key

	xhr.open('GET', request_url, true)
	xhr.onreadystatechange = () ->
		if (xhr.readyState == 4 && xhr.status == 200)
			results = JSON.parse(xhr.responseText).genres
			names = results.map (type) -> type.name
			ids = results.map (type) -> type.id
			for id, index in ids
				localStorage.setItem('genre' + id, names[index])
	xhr.send(null)

# Looks through localStorage for genreID, appends to modal
lookupGenre = (genreID) ->
	document.getElementById('genres').innerHTML += '<span class="genre">' + localStorage.getItem('genre' + genreID) + '</span>'

findGenres()
listMovies()
