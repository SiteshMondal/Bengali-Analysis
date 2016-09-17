library(twitteR)

# First create a CSV file with twitter app credentials with header
# API_KEY,API_SECRET,ACCESS_TOKEN,ACCESS_TOKEN_SECRET
secrets <- read.csv(file = 'credentials.csv', header = TRUE, sep = ',')

setup_twitter_oauth(secrets$API_KEY, secrets$API_SECRET, access_token = secrets$ACCESS_TOKEN, access_secret = secrets$ACCESS_TOKEN_SECRET)
