# Loop through input label names, perform search request for details
listMovies = () ->
	movies = document.getElementsByTagName('label')
	for movie in movies
		movie.addEventListener('click', (event) ->
			event.preventDefault()
			searchTMDb(event.target.innerHTML)
		)

# Search The Movie Database - https://www.themoviedb.org/
searchTMDb = (query) ->
	xhr = new XMLHttpRequest()
	key = '7c0a5517c60b6e558209d52eaf618ad3'
	TMDb_url = 'https://api.themoviedb.org/3/search/movie?api_key=' + key + '&query=' + query
	overlay = document.getElementById('overlay')
	title = document.getElementById('title')
	detail = document.getElementById('details')
	rating = document.getElementById('rating')
	date = document.getElementById('date')
	poster = document.getElementById('poster')

	xhr.open('GET', TMDb_url, true)
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
				# TODO: make this only fire on bg click, not panel
				overlay.classList.remove('open')
			)
	xhr.send(null)

listMovies()

# TODO:
# Save 'watched' to localStorage
# Improve error for no response from TMDb
