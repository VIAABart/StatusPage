require 'rubygems'
require 'bundler'
require 'open-uri'
require 'timeout'

Bundler.require(:default)

require './application'
use Status::Application
run Sinatra::Application