require 'minimage'
require 'cuba'

module Minimage
  class Server < Cuba
    def not_found
      res.status = 404
      halt(res.finish)
    end

    def content_type(stream)
      case stream.byteslice(0, 10)
        when /^GIF8/ then 'image/gif'
        when /^\x89PNG/ then 'image/png'
        when /^\xff\xd8\xff\xe0\x00\x10JFIF/ then 'image/jpg'
        when /^\xff\xd8\xff\xe1(.*){2}Exif/ then 'image/jpg'
        else 'application/octet-stream'
      end
    end
  end
end

Minimage::Server.settings[:cache_expiration] = 3600*24*365

Minimage::Server.define do
  on get, %r{(?:(?:c_(fit|fill|limit)(?:,|\/)|w_(\d+)(?:,|\/)|h_(\d+)(?:,|\/)|g_(north_west|north|north_east|west|center|east|south_west|south|south_east)(?:,|\/))+)([^\\/]+)\.([a-z]{3,})} do |crop_mode, width, height, gravity, uid, format|
    stream = Minimage.fetch(uid)
    not_found unless stream
    stream = Minimage.process(stream, format) do |processor|
      crop_mode = crop_mode.nil? ? :scale : crop_mode.to_sym
      processor.send(crop_mode, width, height, gravity)
    end
    res['Content-Type']  = content_type(stream)
    res['Cache-Control'] = "public, max-age=#{settings[:cache_expiration]}"
    res.write stream
  end

  on get, ':uid\.:format' do |uid, format|
    stream = Minimage.fetch(uid)
    not_found unless stream
    stream = Minimage.process(stream) do |processor|
      processor.format(format)
    end
    res['Content-Type']  = content_type(stream)
    res['Cache-Control'] = "public, max-age=#{settings[:cache_expiration]}"
    res.write stream
  end
end