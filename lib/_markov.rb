require 'marky_markov'

MARKOV = MarkyMarkov::Dictionary.new($bot[:config][:dict_file], 2)

def random_sentence
  MARKOV.generate_1_sentence[0...140]
end

