###
# Blog settings
###

# Time.zone = "UTC"

activate :blog do |blog|
  blog.prefix = 'blog'
  blog.permalink = ':year/:month/:title'
  # blog.sources = ":year-:month-:day-:title.html"
  # blog.taglink = "tags/:tag.html"
  blog.layout = 'blog'
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = ":year.html"
  # blog.month_link = ":year/:month.html"
  # blog.day_link = ":year/:month/:day.html"
  blog.default_extension = '.md'
  blog.tag_template = 'tag.html'
  blog.calendar_template = 'calendar.html'

  blog.paginate = true
  blog.per_page = 6
  # blog.page_link = "page/:num"
end

page '/feed.xml', layout: false
page '/open-source-feed.xml', layout: false

# Assets
activate :sassc
set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'images'
set :font_dir, 'fonts'

# Make external files available to Sprockets
bower_path = File.join(root, 'bower_components')
sprockets.append_path File.join(bower_path, 'bourbon/app/assets/stylesheets')
sprockets.append_path bower_path

bootstrap_path = File.join(bower_path, 'bootstrap-sass/assets')
bootstrap_fonts_path = File.join(bootstrap_path, 'fonts')
sprockets.append_path bootstrap_fonts_path
sprockets.append_path File.join(bootstrap_path, 'javascripts')
sprockets.append_path File.join(bootstrap_path, 'stylesheets')

# Import Bootstrap fonts
Dir.foreach(File.join(bootstrap_fonts_path, 'bootstrap')) do |file|
  next if File.directory? File.join(bootstrap_fonts_path, 'bootstrap', file)
  sprockets.import_asset File.join('bootstrap', file) do |path|
    File.join(config[:font_dir], path)
  end
end

# Do not output assets at wrong paths
ignore 'fonts/bootstrap-sass/*'
ignore 'images/bootstrap-sass/*'

# Add syntax highlighting support
require 'middleman-syntax'
activate :syntax

# Use GH style markdown
set :markdown, tables: true,
  autolink: true,
  gh_blockcode: true,
  fenced_code_blocks: true,
  smartypants: true
set :markdown_engine, :redcarpet

configure :development do
  set :debug_assets, true

  # reload page
  activate :livereload
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
