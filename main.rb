require 'byebug'
require 'nokogiri'
require 'json'

class SafariReader
  def parse
  	file_content = File.read('./Safari Bookmarks.html').gsub(/[\t\n]+/, '')
    part_with_links = /com.apple.ReadingList.+<DL>(.+)<\/DL>/.match(file_content)[0]
    links = part_with_links.scan(%r{(<A[^<]+<\/A>)+}).flatten

    parsed_links = links.map do |link_string|
      link_parsed_data = link_string.scan(%r{HREF="(.+)">(.+)<}).flatten
      {
        name: link_parsed_data[1],
        href: link_parsed_data[0]
      }
    end

    File.write('./parsed_links.json', JSON.pretty_generate(parsed_links))
  end
end

SafariReader.new.parse