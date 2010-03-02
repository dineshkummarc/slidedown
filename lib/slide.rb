require 'base64'
require 'mime/types'

class Slide
  attr_accessor :text, :classes
  
  def initialize(slideshow, text, *classes)
    @slideshow = slideshow
    @text = text
    @classes = classes
    highlight!
    suck_in_images!
  end

  def title
    Nokogiri::HTML(html).at('h1').content
  rescue NoMethodError
    "Slides"
  end
  
  def html
    doc.at('body').to_s
  end

  def suck_in_images!
    # TODO : Make 'alt' attribute optional
    markup.to_s.gsub!(/<img src="([^"]+)".*alt="([^"]+)"[^>]*\s*\/?>/) do |match|
      begin
        file = File.read( @slideshow.base_path.join($1) )
        mime = MIME::Types.of(File.basename( @slideshow.base_path.join($1) ))
        "<img src=\"data:#{mime};base64,#{Base64.encode64(file)}\" alt=\"#{$2}\" />"
      rescue Exception => e
        # TODO : Better error handling
        STDERR.puts "\033[41;1mError!\033[0m Cannot suck image '#{$1}' into src=data: #{e.inspect}"
      end
    end
    return @html
  end
  
  private

  def doc
    @doc ||= Nokogiri::HTML(markup)
  end
  
  def markup
    @markup ||= begin
      self.text = text.split(/\n/).each do |line|
        line.gsub!(/^@@@ ([\w\s]+)/) do
          %(<pre><code rel='#{$1}'>)
        end
        line.gsub!(/^@@@\s*$/, %(</code></pre>))
      end.join("\n")
      RDiscount.new(text).to_html
    end
    # RDiscount.new(text).to_html
  end
  
  def highlight!
    # STDERR.puts doc.search('pre code').inspect
    doc.search('pre code').each do |node|
      lexer = node['rel'] || :ruby
      lexted_text = Albino.new(node.text, lexer).colorize.strip
      # STDERR.puts '---', lexted_text, '---'
      highlighted = Nokogiri::HTML(lexted_text).at('div')
      # STDERR.puts '---', highlighted.inspect, '---'
      
      klasses = highlighted['class'].split(/\s+/)
      klasses << lexer
      highlighted['class'] = klasses.join(' ')
      
      node.replace(highlighted)
    end
  end
  
  alias_method :to_str, :html

end