require 'CSV'

module Openable
  def read_from(file)
    CSV.readlines(file, headers: true, header_converters: :symbol))
  end
end
