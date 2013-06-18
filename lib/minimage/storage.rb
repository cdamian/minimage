module Minimage
  module Storage
    class Base
      def configure
        yield self
      end

      def store!(file)
        raise NotImplementedError.new
      end

      def fetch!(uid)
        raise NotImplementedError.new
      end
    end
  end
end