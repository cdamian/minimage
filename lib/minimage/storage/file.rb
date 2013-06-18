require 'minimage/storage'
require 'fileutils'

module Minimage
  module Storage
    class File < Base
      attr_accessor :root_path

      def store!(pathname)
        atime = pathname.mtime
        rnd   = '%05d' % (rand(99999) + 1)
        uid   = "#{atime.to_i}_#{rnd}"

        path     = pathname.to_path
        new_path = ::File.expand_path(::File.join(root_path, atime.strftime('%Y/%m/%d/%H/%M'), uid))

        FileUtils.mkdir_p(::File.dirname(new_path)) unless ::File.exists?(::File.dirname(new_path))
        FileUtils.copy(path, new_path) unless new_path == path
        uid
      rescue Errno::EACCES => e
        raise Minimage::Storage::Error.new
      end

      def fetch!(uid)
        matchdata = uid.match(/^(\d+)_\d{5}$/)
        raise Minimage::Storage::NotFound.new unless matchdata

        atime = Time.at(matchdata.captures.shift.to_i)
        path  = ::File.expand_path(::File.join(root_path, atime.strftime('%Y/%m/%d/%H/%M'), uid))
        ::File.open(path, "rb") { |f| f.read }
      rescue Errno::ENOENT => e
        raise Minimage::Storage::NotFound.new
      end

    end
  end
end