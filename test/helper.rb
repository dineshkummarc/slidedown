$LOAD_PATH << File.join(File.dirname(__FILE__), *%w[.. lib])

require 'rubygems'
require 'nokogiri'
require 'bacon'
require File.join(File.dirname(__FILE__), *%w[.. lib slidedown])

module TestHelp
  def slide(*args)
    Slide.new(SlideDown.new(@markdown), @markdown, *args)
  end
  
  def slidedown
    SlideDown.new(@markdown)
  end

  def with_markdown(markdown)
    @markdown = markdown.gsub(/^\s*\|/, '')
  end

  def with_markdown_file
    @markdown = File.join( File.dirname(File.expand_path(__FILE__)), '..', 'example', 'slides.md' )
  end
end