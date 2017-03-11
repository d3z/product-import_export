require 'json'

class JSONProductExporter

  def export(products)
    # let's not get too clever about this
    JSON.dump(products)
  end

end