module Minimage
  module Processor
    class Base
      attr_reader :stream

      def initialize(stream, format = nil)
        @format = format
        @stream = stream
      end

      def format(format)
        raise NotImplementedError.new
      end

      def limit(width, height = nil, gravity = nil)
        raise NotImplementedError.new
      end

      def fill(width, height = nil, gravity = nil)
        raise NotImplementedError.new
      end

      def fit(width, height = nil, gravity = nil)
        raise NotImplementedError.new
      end

      def scale(width, height = nil, gravity = nil)
        raise NotImplementedError.new
      end
    end
  end
end