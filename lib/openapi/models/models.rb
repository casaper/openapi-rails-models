# frozen_string_literal: true

require 'zeitwerk'

Zeitwerk::Loader.new.then do |loader|
  loader.push_dir "#{__dir__}/.."
  loader.setup
end

module Openapi
  # Main namespace.
  module Models
  end
end
