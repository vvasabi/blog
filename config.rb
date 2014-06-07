###
# Blog settings
###

# Time.zone = "UTC"

activate :blog do |blog|
  blog.prefix = "blog"
  blog.permalink = ":year/:month/:title"
  # blog.sources = ":year-:month-:day-:title.html"
  # blog.taglink = "tags/:tag.html"
  blog.layout = "blog"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = ":year.html"
  # blog.month_link = ":year/:month.html"
  # blog.day_link = ":year/:month/:day.html"
  blog.default_extension = ".md"
  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  blog.paginate = true
  blog.per_page = 6
  # blog.page_link = "page/:num"
end

page "/feed.xml", :layout => false
page "/open-source-feed.xml", :layout => false

### 
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
compass_config do |config|
  config.output_style = :compressed
end

set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'images'

# Add syntax highlighting support
require 'middleman-syntax'
activate :syntax

# Use GH style markdown
set :markdown, :tables => true,
    :autolink => true,
    :gh_blockcode => true,
    :fenced_code_blocks => true,
    :smartypants => true
set :markdown_engine, :redcarpet

configure :development do
  set :debug_assets, true

  # reload page
  activate :livereload, :apply_js_live => true, :apply_css_live => true
  config[:file_watcher_ignore] << %r{\.idea\/}
end

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  # activate :cache_buster

  # Use relative URLs
  # activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"
end

