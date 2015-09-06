Twittbot::BotPart.new :random_tweet do
  every 15, :minutes do
    bot.tweet random_sentence
  end
end
