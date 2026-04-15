source "https://rubygems.org"
# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
gem "jekyll", "~> 4.3.4"
# This is the default theme for new Jekyll sites. You may change this to anything you like.
# gem "minima", "~> 2.5"
# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem "github-pages", group: :jekyll_plugins
# If you have any plugins, put them here!
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.12"
end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
# platforms :mingw, :x64_mingw, :mswin, :jruby do
#   gem "tzinfo", ">= 1", "< 3"
#   gem "tzinfo-data"
# end

# Performance-booster for watching directories on Windows
# gem "wdm", "~> 0.1", :platforms => [:mingw, :x64_mingw, :mswin]

# Pin ffi to 1.17.3 for arm64-darwin24 (1.17.1 fails to build with CFI/assembler errors)
gem "ffi", ">= 1.17.3"

# Ruby 3.4+ no longer auto-loads some standard libraries like csv, base64, logger.
# They must be explicitly included in the Gemfile for Netlify.
gem "csv"
gem "base64"
gem "logger"

gem "webrick"
# gem "did_you_mean"