require_relative '../config/environment'
require 'pry'
require_relative './helpers.rb'


welcome
user = username
choice = menu

while choice != 5 do
  choice = delegate(choice, user)
end
