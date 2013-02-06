#!/usr/bin/ruby
require 'rubygems'
require 'rexml/document'

home = '/Users/gjescandon/gwork/'
destroyTemplateHeader = '<?xml version="1.0" encoding="UTF-8"?><Package xmlns="http://soap.sforce.com/2006/04/metadata"><version>26.0</version>'
destroyTemplateFooter = '</Package>'
# sfdcObjectParser will return all fieldNames for the selected object 

objects = Array.new

ARGV.each do|a|
  objects << a
end

if (objects.length != 2) then
  puts 'Expecting 2 argument: sfdcObjectParser arg1 arg2'
  puts wh
end

repoName = objects[0]
objName = objects[1]
fpath = home + repoName + '/src/objects/' + objName + '.object'


### now with REXML 

metadata = REXML::Document.new File.open(fpath)
fieldnames = Array.new
REXML::XPath.each(metadata, "//fullName") do |node|
  fieldnames << node.text
end

puts dpath = home + 'sfdc-destroy/src/destructiveChanges.xml'
File.open(dpath, 'w') do |dfile|
  dfile.puts destroyTemplateHeader
  dfile.puts '<types><name>CustomField</name>'
  REXML::XPath.each(metadata, "//fullName") do |node|
    dfile.puts '<members>' + objName + '.' + node.text + '</members>'
  end
  dfile.puts '</types>'
  dfile.puts destroyTemplateFooter
end

