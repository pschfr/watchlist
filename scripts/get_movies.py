#!/usr/bin/env python3

# Import system stuff
import os

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
print(movie_note)
