# Globals
api_key = '7c0a5517c60b6e558209d52eaf618ad3'
TMDb_url = 'https://api.themoviedb.org/3/'
logging = false

# Loops through inputs and label names, then performs search request for details & adds watched movies to localStorage
listMovies = () ->
	for movie in document.getElementsByTagName('label')
		if movie.htmlFor != 'hide'
			movie.addEventListener('click', (event) ->
				event.preventDefault()
				searchTMDb(event.target.innerHTML)
			)
	for input in document.getElementsByTagName('input')
		if input.id != 'hide'
			if localStorage.getItem(input.name)
				document.getElementById(input.name).parentElement.title = 'watched'
				document.getElementById(input.name).setAttribute('checked', 'checked')
			input.addEventListener('click', (event) ->
				if event.target.checked
					localStorage.setItem(event.target.name, 'watched')
					event.target.parentElement.title = 'watched'
				else
					localStorage.removeItem(event.target.name)
					event.target.parentElement.title = ''
			)
			# Press `Enter` when focused on an input to open the modal
			input.addEventListener('keyup', (event) ->
				if (event.keyCode == 13)
					document.querySelector('label[for="' + event.target.id + '"]').click()
			)

# Search The Movie Database - https://www.themoviedb.org/
searchTMDb = (query) ->
	xhr = new XMLHttpRequest()
	request_url = TMDb_url + 'search/movie?api_key=' + api_key + '&query=' + query

	xhr.open('GET', request_url, true)
	xhr.onreadystatechange = () ->
		if (xhr.readyState == 4 && xhr.status == 200)
			results = JSON.parse(xhr.responseText).results
			if logging
				console.log(results)
			if results[0]
				# Append title, details, rating, and date
				document.getElementById('title').innerHTML = '<a href="https://themoviedb.org/movie/' + results[0].id + '" target="_blank" rel="noreferrer noopener">' + results[0].original_title + '</a>'
				document.getElementById('details').innerHTML = results[0].overview
				document.getElementById('rating').innerHTML = results[0].vote_average
				# Format date properly
				release_date = new Date(results[0].release_date.replace(/-/g, "/"))
				monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
				document.getElementById('date').innerHTML = monthNames[release_date.getMonth()] + ' ' + release_date.getDate() + ', ' + release_date.getFullYear()
				# Append poster
				document.getElementById('poster').src = 'https://image.tmdb.org/t/p/w500' + results[0].poster_path
				# Background image
				document.getElementById('panel').style.backgroundImage = 'url("https://image.tmdb.org/t/p/w1280' + results[0].backdrop_path + '")'
				# Finds genre based on ID
				document.getElementById('genres').innerHTML = ''
				for genreID in results[0].genre_ids
					lookupGenre(genreID)
				# Find trailer from ID
				lookupMovies(results[0].id)
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
			if logging
				console.log(results)
			names = results.map (type) -> type.name
			ids = results.map (type) -> type.id
			for id, index in ids
				localStorage.setItem('genre' + id, names[index])
	xhr.send(null)

# Looks through localStorage for genreID, appends to modal
lookupGenre = (genreID) ->
	document.getElementById('genres').innerHTML += '<span class="genre">' + localStorage.getItem('genre' + genreID) + '</span>'

# Lookup movie trailers
lookupMovies = (movieID) ->
	xhr = new XMLHttpRequest()
	request_url = TMDb_url + 'movie/' + movieID + '/videos?api_key=' + api_key
	youtube_url = 'https://www.youtube.com/watch?v='

	xhr.open('GET', request_url, true)
	xhr.onreadystatechange = () ->
		if (xhr.readyState == 4 && xhr.status == 200)
			response = JSON.parse(xhr.responseText)
			if response.results.length
				results = JSON.parse(xhr.responseText).results[0]
				if logging
					console.log(results)
				if results.site == "YouTube"
					document.getElementById('trailer').style.display = 'inline-block'
					document.getElementById('trailer').href = youtube_url + results.key
					document.getElementById('type').innerHTML = results.type
			else
				document.getElementById('trailer').style.display = 'none'
	xhr.send(null)

# Press `Esc` to close modal
document.onkeyup = (event) ->
	if (event.keyCode == 27)
		document.getElementById('overlay').classList.remove('open')

# Hides watched videos on click
document.getElementById('hide').addEventListener('click', (event) ->
	for movie in document.getElementsByClassName('movie')
		if movie.title
			if document.getElementById('hide').checked
				movie.style.display = 'none'
			else
				movie.style.display = ''
)

# Run everything on load
findGenres()
listMovies()
