
APP_ROOT = File.dirname __FILE__

$:.unshift File.join(APP_ROOT, 'lib')
require 'scraper.rb'
require 'nokogiri'
require 'httparty'
require 'byebug'

url = "https://blockwork.cc/"
scraper = Scraper.new(url)
scraper.scrap_handler
