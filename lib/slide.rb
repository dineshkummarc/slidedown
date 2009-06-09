require 'base64'
require 'mime/types'

class Slide
  attr_accessor :text, :classes
  
  def initialize(slideshow, text, *classes)
    @slideshow = slideshow
    @text = text
    @classes = classes
  end

  def title
    Nokogiri::HTML(html).at('h1').content
  rescue NoMethodError
    "Slides"
  end
  
  def html
    # Yikes....
    return @html if defined? @html
    @html = convert_to_html!
    suck_in_images!
    return @html
  end

  private

  def convert_to_html!
    MakersMark::Generator.new(@text).to_html
  end

  def suck_in_images!
    # TODO : Make 'alt' attribute optional
    @html.to_s.gsub!(/<img src="([^"]+)".*alt="([^"]+)"[^>]*\s*\/?>/) do |match|
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
end