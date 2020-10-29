#!/usr/bin/env python3

# Import system stuff
import os
import json

# Import and init .env variables
from dotenv import load_dotenv
load_dotenv()

# Import and init Google Keep API
import gkeepapi
keep = gkeepapi.Keep()
success = keep.login(os.getenv('KEEP_EMAIL'), os.getenv('KEEP_PWD'))

keep.sync()

# Connect to the specific movie note
movie_note = keep.get(os.getenv('MOVIE_NOTE_ID'))

# Returns note to Node.js
# print(movie_note)

# Print opening of JSON object
# print('"movies": {')

# Delcare this for use later
new_movie_list = ''

# Loop over movie data, breaking on new lines
for individual_movie in str(movie_note).split('\n'):
	# If this individual_movie isn't the title, continue...
	if individual_movie.find("Movie List") == -1:
		# Now to actually convert to a True/False list
		# Test if individual_movie has checked box
		if "☑ " in individual_movie:
			# Remove it
			individual_movie = individual_movie.strip("☑ ")
			watched_status = True
		# Now the same for unchecked boxes
		elif "☐ " in individual_movie:
			# Remove it
			individual_movie = individual_movie.strip("☐ ")
			watched_status = False

		# Concatenate it all together
		# movie_string = f'\"{individual_movie}\": {{\"watched\": {watched_status}}}'
		movie_string = {individual_movie: {"watched": {watched_status}}}

		# Load in JSON object
		movie_json = json.loads(new_movie_list)

		# Append to JSON object
		movie_json.update(movie_string)

		print(movie_string)

# Close JSON object
# print('}')

print(json.dumps(new_movie_list))
