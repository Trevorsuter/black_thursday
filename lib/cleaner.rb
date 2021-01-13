require 'CSV'
require 'time'

class Cleaner

  def clean_id(id)
    id.to_i
  end

  def clean_name(name)
    name
  end

  def clean_date(date)
    Time.parse(date)
  end

  def clean_status(status)
    status.to_sym
  end
end