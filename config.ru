require 'rubygems'
require 'bundler'
require 'open-uri'

Bundler.require(:default)

require './application'
use Status::Application
run Sinatra::Application