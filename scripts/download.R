library (twitteR)

# First create a CSV file with twitter app credentials with header
# API_KEY,API_SECRET,ACCESS_TOKEN,ACCESS_TOKEN_SECRET

# Load secrets, keywords and geolocations
twitter.secrets   <- read.csv (file = './twitter/credentials.csv', header = TRUE, sep = ',')
twitter.keywords  <- read.csv (file = './twitter/keywords.csv', header = TRUE, sep = ',')
twitter.locations <- read.csv (file = './twitter/geolocations.csv', header = TRUE, sep = ',')

# Set-up twitter oauth authentication
setup_twitter_oauth (twitter.secrets$KEY, twitter.secrets$SECRET, 
                     access_token  = twitter.secrets$TOKEN, 
                     access_secret = twitter.secrets$TOKEN_SECRET)

# Create an empty dataframe to save the tweets
tweets.df <- data.frame(text <- character())

# Iterate over keywords and locations to download tweets
for (location in twitter.locations$GEOLOCATION) {
  for (keyword in twitter.keywords$KEYWORDS) {
    tweets.list <- searchTwitter(toString(keyword), 
                                 lang = 'en', 
                                 geocode = paste(toString(location), '20mi', sep = ','))
    if (length(tweets.list) > 0) {
      tweets.text <- twListToDF(tweets.list)['text']
      tweets.df   <- rbind(tweets.df, tweets.text)
    }
  }
}

# Filter the data
regex.pattern    <- '(@|#|https?)[-a-zA-Z0-9@:%._/+~#=]*|(rt|RT)|[\n\t\r]'
tweets.nodup     <- unique(na.omit(tweets.df[,1]))
tweets.filtered  <- gsub(regex.pattern, '', tweets.nodup)
tweets.data      <- data.frame(TWEETS = iconv(tweets.filtered, to = "ASCII", sub = ''))

# Append the data to the previously downloaded data
tweets.prev  <- read.csv('./data/tweets.csv', header = TRUE, sep = ',')
tweets.total <- unique(rbind(tweets.prev['TWEETS'], tweets.data['TWEETS']))
write.csv(tweets.total, './data/tweets.csv')

