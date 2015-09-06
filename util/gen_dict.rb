#!/usr/bin/env ruby
# This script generates the Markov dictionary.
#
# Usage:
# FETCH=1 GENERATE=1 ./gen_dict.rb

require 'json'
require 'httparty'
require 'nokogiri'
require 'marky_markov'

DESCR_FILE = File.expand_path '../product_descriptions.txt', __FILE__
DICT_FILE = File.expand_path '../../data/products', __FILE__

if ENV['FETCH']
  products = JSON.parse HTTParty.get('http://bad-dragon.com/products/getproducts').body
  urls = products.select{ |x| x['cat_id'] == '1' }.map{ |x| x['link_url'] }

  begin; File.unlink DESCR_FILE; rescue => _; end

  urls.each do |url|
    puts url.sub('http://bad-dragon.com/products/', '')
    document = Nokogiri::HTML.parse HTTParty.get(url).body
    File.open DESCR_FILE, 'a' do |f|
      f.puts document.css('p[style="line-height:1.35em;"]').map{ |p| p.content.strip } * "\n"
      f.puts
    end
  end
end

if ENV['GENERATE']
  begin; File.unlink DICT_FILE ; rescue => _; end
  puts '>> Generating markov dictionary'
  markov = MarkyMarkov::Dictionary.new(DICT_FILE, 2)
  markov.parse_file DESCR_FILE
  markov.save_dictionary!
  puts '>> Done'
end

