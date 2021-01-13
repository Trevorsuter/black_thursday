require 'CSV'

module Openable
  def read_from(file)
    CSV.read(file, headers: true, header_converters: :symbol)
  end

  def open_from(file)
    CSV.open(file, headers: true, header_converters: :symbol)
  end
end
