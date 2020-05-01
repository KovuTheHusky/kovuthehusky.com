require 'date'
require 'json'
require 'net/http'

json = JSON.parse(File.read('_data/projects.json'))

since = Date.parse(json['since']).to_s
today = Date.today.to_s

if (since != today)
  out = `node_modules/\@ghuser/github-contribs/cli.js --quiet --since #{since} KovuTheHusky`
  out.each_line do |line|
    line = line.chomp
    if !json['contributions'].include? line
      json['contributions'] << line
    end
  end
  json['contributions'] = json['contributions'].sort_by(&:downcase)
end

json['owned'] = {}
['active', 'inactive', 'unsupported', 'suspended', 'abandoned', 'wip', 'concept', 'moved', 'unknown'].each do |status|
  json['owned'][status] = []
end
json['contributed'] = []
json['contributions'].each do |repo|
  uri = URI.parse('https://api.github.com/repos/' + repo)
  request = Net::HTTP::Get.new(uri)
  request["Authorization"] = "token " + ARGV[0]
  req_options = {
    use_ssl: uri.scheme == "https",
  }
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end

  if response.code == '200'
    response = JSON.parse(response.body)
    owner = response['owner']['login']
    name = response['name']
    project = {
      "name": name,
      "owner": owner,
      "description": response['description']
    }
    if (owner == 'KovuTheHusky')
      homepage = response['homepage']
      homepage_text = "Visit"
      if homepage.nil? || homepage.empty? || homepage.start_with?('https://kovuthehusky.com/projects')
        homepage = nil
        homepage_text = nil
      end
      if homepage.nil?
        uri = URI.parse("https://api.github.com/repos/#{repo}/releases/latest")
        request = Net::HTTP::Get.new(uri)
        request["Authorization"] = "token " + ARGV[0]
        req_options = {
          use_ssl: uri.scheme == "https",
        }
        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end
        if response.code == '200'
          homepage = "https://github.com/#{repo}/releases/latest"
          homepage_text = "Download"
        end
      end
      if !homepage.nil?
        project['button'] = {
          'text': homepage_text,
          'href': homepage
        }
      end

      project['source'] = "https://github.com/#{repo}"

      slug = name.downcase.gsub(/[^a-z0-9]/, '')

      if File.exists?("images/projects/icons/#{slug}.svg")
        project['icon'] = "/images/projects/icons/#{slug}.svg"
      elsif File.exists?("images/projects/icons/#{slug}.png")
        project['icon'] = "/images/projects/icons/#{slug}.png"
      end

      if File.exists?("videos/projects/previews/#{slug}.mp4")
        project['preview_video'] = "/videos/projects/previews/#{slug}.mp4"
      elsif File.exists?("images/projects/previews/#{slug}.png")
        project['preview_image'] = "/images/projects/previews/#{slug}.png"
      end

      status = Net::HTTP.get(URI("https://raw.githubusercontent.com/#{repo}/master/README.md")).lines.first.match /http[s]?:\/\/.*repostatus\.org\/badges\/.+?\/(.+?)\.svg/
      if status && status.length() > 0
        status = status[1]
        if status == 'wip'
          status = 'WIP'
        else
          status[0] = status[0,1].upcase
        end
      else
        status = 'Unknown'
      end
      project['status'] = status

      json['owned'][status.downcase] << project
    else
      json['contributed'] << project
    end
  elsif response.code == '404'
    json['contributions'].delete(repo)
  end
end

json['since'] = today

file = File.open("_data/projects.json", "w")
file.puts(JSON.pretty_generate(json))
file.close

