class Slide
  attr_accessor :text, :classes
  
  def initialize(text, *classes)
    @text = text
    @classes = classes
  end

  def title
    Nokogiri::HTML(html).at('h1').content
  rescue NoMethodError
    "Slides"
  end
  
  def html
    MakersMark::Generator.new(@text).to_html
  end
end