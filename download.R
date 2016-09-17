library(twitteR)

# First create a CSV file with twitter app credentials with header
# API_KEY,API_SECRET,ACCESS_TOKEN,ACCESS_TOKEN_SECRET

# Load secrets, keywords and geolocations
secrets <- read.csv(file = 'credentials.csv', header = TRUE, sep = ',')
keywords <- read.csv(file = 'keywords.csv')
locations <- read.csv(file = 'geolocations.csv')

# Set-up twitter oauth authentication
setup_twitter_oauth(secrets$KEY, secrets$SECRET, access_token = secrets$TOKEN, access_secret = secrets$TOKEN_SECRET)
