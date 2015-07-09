require 'rubygems'
require 'json'
require 'FFaker'
require 'set'
require 'benchmark'
require 'csv'
require 'ruby-progressbar'
require './userid'
require './reporting_chain'
require './helpers'

require './generate'
require './import'

generate = ARGV[0]
import = ARGV[1]
DATASETSIZE = 100_000

if ARGV.size == 0
	puts "Please enter a command (either 'generate', 'import' or both)"
end

if ARGV.size > 2
	puts "Too many arguments"
end

if ARGV.size > 0 && !ARGV.include?("generate") || !ARGV.include?("import")
	puts "invalid command"
end 

if ARGV.include?("generate")
	Generate.new
end
if ARGV.include?("import")
	Import.new
end







