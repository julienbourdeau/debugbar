require 'net/http'
require 'json'

fixtures_dir = File.expand_path('../fixtures/requests', __FILE__)

puts "Deleting old fixtures in #{fixtures_dir}"
Dir.glob("#{fixtures_dir}/*").each { |p| File.delete(p) }

Net::HTTP.start('127.0.0.1', 3000) do |http|
  [
    '/post-list',
    '/slow-page',
    '/random',
    '/post/240',
    '/api/jobs?name=refresh&post_id=123',
    '/api/jobs?name=send_email&post_id=123',
    '/api/errors?code=500',
  ].each do |path|
    puts "Requesting #{path}"
    http.request Net::HTTP::Get.new(path)
    sleep 0.5
  end

  puts "Requesting debugbar data"
  response = http.request Net::HTTP::Get.new('/_debugbar/poll')
  data = JSON.parse(response.body)
  data.each_with_index do |item, idx|
    name = ("%03d" % (idx +1)) + '-' + item['meta']['controller'] + '-' + item['meta']['action']
    File.write("#{fixtures_dir}/#{name}.json", JSON.pretty_generate(item))
  end
end

