programDirectory=$(dirname "$0")
blogDirectory="$programDirectory/blog"

# FIXME: Find a way to call "bundle exec" without changing directories first. Setting BUNDLE_GEMFILE
# is not enough and I get the error:
# [[
# Error: could not read file /.../blog/vendor/bundle/ruby/2.6.0/gems/jekyll-4.2.0/lib/site_template/_posts/0000-00-00-welcome-to-jekyll.markdown.erb: Invalid \\
# date '<%= Time.now.strftime('%Y-%m-%d %H:%M:%S %z') %>': Document 'blog/vendor/bundle/ruby/2.6.0/gems/jekyll-4.2.0/lib/site_template/_posts/0000-00-00-welcome-to-jekyll.markdown.erb' \\
# does not have a valid date in the YAML front matter.
# ERROR: YOUR SITE COULD NOT BE BUILT:
# ]]
alias start-server="cd '$blogDirectory' && bundle exec jekyll serve --livereload --open-url"
