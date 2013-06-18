require 'minimage/processor/mini_magick'
require 'minimage/storage/file'
require 'nesty'

module Minimage
  extend self

  Error = Class.new(Nesty::NestedStandardError)

  attr_accessor :storage, :processor

  def storage
    @storage ||= Minimage::Storage::File.new
  end

  def processor
    @processor ||= Minimage::Processor::MiniMagick.public_method(:new)
  end

  def configure
    yield self
  end

  def process(stream, format = nil, &block)
    p = processor.call(stream, format)
    block.call(p)
    p.stream
  end

  def store(path)
    storage.store!(path)
  rescue => e
    raise Error.new
  end

  def fetch(uid)
    storage.fetch!(uid)
  end
end