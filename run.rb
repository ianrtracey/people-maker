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

if generate.nil? && import.nil?
	abort("Please enter a command (either 'generate', 'import' or both)")
end

if generate != "generate"
	abort("#{generate} is not a command")
end
if import != "import" && !import.nil?
	abort("#{import} is not a command")
end

if !generate.nil?
	Generate.new
end
if !import.nil?
	Import.new
end







