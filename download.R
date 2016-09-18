# Filter the downloaded tweets
filter_tweets <- function(twt) {
  twt <- gsub('(#|@|https?)[-a-zA-Z0-9@:%._//+~#=]*|(rt|RT)|[\n\t\r]', ' ', na.omit(twt))
  return(unique(na.omit(iconv(twt, to = 'ASCII', sub = ''))))
}

library(twitteR)

# First create a CSV file with twitter app credentials with header
# API_KEY,API_SECRET,ACCESS_TOKEN,ACCESS_TOKEN_SECRET

# Load secrets, keywords and geolocations
secrets <- read.csv(file = './twitter/credentials.csv', header = TRUE, sep = ',')
keywords <- read.csv(file = './twitter/keywords.csv', header = TRUE, sep = ',')
locations <- read.csv(file = './twitter/geolocations.csv', header = TRUE, sep = ',')

# Set-up twitter oauth authentication
setup_twitter_oauth(secrets$KEY, secrets$SECRET, access_token = secrets$TOKEN, access_secret = secrets$TOKEN_SECRET)

tw = data.frame(text = NA)

for (coordinate in locations$GEOLOCATION) {
  for (search_word in keywords$KEYWORDS) {
    print(paste(search_word, coordinate, sep = ' '))
    d <- twListToDF(searchTwitter(toString(search_word), lang = 'en', geocode = paste(toString(coordinate), "20mi", sep = ",")))
    print(d$text)
    # tw <- rbind(tw, apply(d$text, 1, filter_tweets))
    # print(tw)
  }
}
colnames(tw) <- c('TWEETS')
write.csv(tw, file = './data/newtweets.csv')
pre <- read.csv(file = './data/tweets.csv')
tw <- rbind(pre, tw)

write.csv(tw, file = './data/tweets.csv')