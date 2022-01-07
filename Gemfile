source "https://rubygems.org"

gem "jekyll", "~> 4.2"
# gem "github-pages", group: :jekyll_plugins

group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.16"
  gem "jekyll-file-size", "~> 0.0.7"
  gem "jekyll-redirect-from", "~> 0.16.0"
end

install_if -> { RUBY_PLATFORM =~ %r!mingw|mswin|java! } do
  gem "tzinfo", "~> 2.0"
  gem "tzinfo-data"
end

gem "wdm", "~> 0.1", :install_if => Gem.win_platform?

gem "nokogiri", "~> 1.13"

gem "webrick", "~> 1.7" # TODO: Remove this once jekyll releases https://github.com/hrldcpr/poole/commit/bafd481f3347283c2edabdb56ee4a3b4b655efc1
