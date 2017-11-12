require 'pry'
require 'csv'
require 'yaml'


def put_phrase(top_hash, phrase, count)
  words = phrase.split

  words.inject(top_hash) do |hash, word|
    if hash[word]
      hash[word].first
    else

      hash[word] = [{}, count.to_i] # if count.to_i > 10
      hash
    end
  end
  top_hash
end


def find(top_hash, phrase)
  words = phrase.split
  words.inject([top_hash, 0]) do |el, word|
    hash = el.first
    if hash[word]
      hash[word]
    else
      [{}, 0]
    end
  end
end


hash = {}

(2..5).each do |i|
  # csv = CSV.read("data/ngrams/ngrams.info/w#{i}_.txt")
  # csv.shift
  csv = CSV.read("data/ngrams/ngrams.info/w#{i}_u.txt", col_sep: "\t")

  csv.each do |el|
    count = el.shift
    phrase = el.join(' ')
    hash = put_phrase(hash, phrase, count)
  end
end

hash.delete_if {|_key, value| value.first.size == 0 }

require 'pry'; binding.pry

# File.write('hash.yml', hash.to_yaml)
