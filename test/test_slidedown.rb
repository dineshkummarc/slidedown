require File.join(File.dirname(__FILE__), 'helper')

describe 'SlideDown' do
  extend TestHelp
  
  it 'finds slides' do
    with_markdown <<-MD
    |# First
    |
    |!SLIDE
    |
    |# Second
    MD
    slidedown.slides.length.should.equal(2)
  end
  
  it 'generates HTML from markdown' do
    with_markdown <<-MD
    |!SLIDE
    |# The title
    |!SLIDE
    MD
    Nokogiri::HTML(slidedown.render).at('h1').should.not.be.nil
  end
<<<<<<< HEAD

  it 'generates HTML from file' do
    with_markdown_file
    Nokogiri::HTML(slidedown.render).at('h1').should.not.be.nil
    Nokogiri::HTML(slidedown.render).at('h1').content.should.equal "Introducing slidedown"
  end

=======
  
>>>>>>> 008941d... More fixes
  it 'adds class names to slides' do
    with_markdown <<-MD
    |# This is the title
    |!SLIDE awesome
    |# The title
    MD
    second_slide = Nokogiri::HTML(slidedown.render).search('#track > div')[1]
    second_slide['class'].should.include('awesome')
  end
  
  it 'syntax highlights' do
    with_markdown <<-MD
    |
    |    def code
    |      :foo
    |    end
    |
    MD
    Nokogiri::HTML(slidedown.render).at('.highlight.ruby').should.not.be.nil
  end
  
  # this one is hard
  it 'allows custom lexer' do
    with_markdown <<-MD
    |@@@ js
    |  (function() { })();
    |@@@
    MD
    # slidedown.render
    Nokogiri(slidedown.render).at('.highlight.js').should.not.be.nil
  end
<<<<<<< HEAD

  it 'has correct <title>' do
    with_markdown <<-MD
    |# Special
    MD
    Nokogiri::HTML(slidedown.render).at('title').content.should.equal 'Special [1/1]'
    with_markdown <<-MD
    |## Special
    MD
    Nokogiri::HTML(slidedown.render).at('title').content.should.equal 'Slides [1/1]'
    with_markdown <<-MD
    |<!-- This page is intentionally left blank -->
    MD
    Nokogiri::HTML(slidedown.render).at('title').content.should.equal 'Slides [1/1]'
  end
=======
>>>>>>> 008941d... More fixes
end