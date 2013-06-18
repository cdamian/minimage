require 'minimage/processor'
require 'mini_magick'

module Minimage
  module Processor
    class MiniMagick < Base

      def format(format)
        manipulate! do |img|
          img.format format.to_s.downcase
          img
        end
      end

      def limit(width, height = nil, gravity = nil)
        manipulate! do |img|
          img.resize "#{width}x#{height}>" if width && height
          img.resize "#{width}" if width
          img.resize "x#{height}" if height
          img
        end
      end

      def fill(width, height, gravity = :center)
        manipulate! do |img|
          if width && height
            width   = width.to_i
            height  = height.to_i
            gravity = :center unless gravity
            gravity = gravity.to_s.capitalize.gsub(/(?:_)([a-z\d]*)/i) { $1.capitalize }
            cols, rows = img[:dimensions]
            img.combine_options do |c|
              if width != cols || height != rows
                scale_x = width/cols.to_f
                scale_y = height/rows.to_f
                if scale_x >= scale_y
                  cols = (scale_x * (cols + 0.5)).round
                  rows = (scale_x * (rows + 0.5)).round
                  c.resize "#{cols}"
                else
                  cols = (scale_y * (cols + 0.5)).round
                  rows = (scale_y * (rows + 0.5)).round
                  c.resize "x#{rows}"
                end
              end
              c.gravity gravity
              c.background "rgba(255,255,255,0.0)"
              c.extent "#{width}x#{height}" if cols != width || rows != height
            end
          else
            img.resize "#{width}" if width
            img.resize "x#{height}" if height
          end
          img
        end
      end

      def fit(width, height = nil, gravity = nil)
        manipulate! do |img|
          img.resize "#{width}x#{height}" if width && height
          img.resize "#{width}" if width
          img.resize "x#{height}" if height
          img
        end
      end

      def scale(width, height = nil, gravity = nil)
        manipulate! do |img|
          img.resize "#{width}x#{height}!" if width && height
          img.resize "#{width}" if width
          img.resize "x#{height}" if height
          img
        end
      end

      private

      def manipulate!
        image = ::MiniMagick::Image.read(stream)
        image.format(@format.to_s.downcase) if @format
        image = yield(image)
        @stream = image.to_blob
      rescue ::MiniMagick::Error, ::MiniMagick::Invalid => e
        raise Minimage::Error.new
      end
    end
  end
end