require 'rubygems'
require 'nokogiri'
require 'rdiscount'
require 'makers-mark'
require 'erb'
require 'pathname'
require File.join(File.dirname(__FILE__), 'slide')

$SILENT = true

class SlideDown
  attr_reader :classes, :base_path

  def self.render(args)
    new(*args).render
  end

  def initialize(path)
    @path = path
    @base_path = Pathname.new( File.dirname(@path) )
    @raw  = ensure_first_slide_valid( read_source_document(@path) )
    extract_classes!
  end

  def slides
    @slides ||= lines.map { |text| slide = Slide.new(self, text, *@classes.shift) }
  end

  def read(path)
    File.read(File.dirname(__FILE__) + '/../templates/%s' % path)
  end

  def render
    template = File.read(File.dirname(__FILE__) + '/../templates/template.erb')
    ERB.new(template).result(binding)
  end

  private

  def read_source_document(path)
    File.read(File.join(Dir.pwd, path))
  end

  def ensure_first_slide_valid(raw)
    # Ensures that the first slide has proper !SLIDE declaration
    raw =~ /\A!SLIDE/ ? raw : "!SLIDE\n#{raw}"
  end

  def lines
    @lines ||= @raw.split(/^!SLIDE\s*([a-z\s]*)$/) \
      .reject { |line| line.empty? }
  end

  def parse_snippets(slide)
    slide.gsub!(/@@@\s([\w\s]+)\s*$/, %(<pre class="#{$1}"><code>))
    slide.gsub!(/@@@\s*$/, %(</code></pre>))
  end

  # These get added to the dom.
  def stylesheets
    Dir[Dir.pwd + '/*.css'].map { |path| File.read(path) }
  end

  def jabascripts
    Dir[Dir.pwd + '/*.js'].map { |path| File.read(path) }
  end

  def extract_classes!
    @classes = []
    @raw.gsub!(/^!SLIDE\s*([a-z\s]*)$/) do |klass|
      @classes << klass.to_s.chomp.gsub('!SLIDE', '')
      "!SLIDE"
    end ; @classes
  end
end
