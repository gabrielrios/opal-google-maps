class ReverseGeocoder
  def initialize(location)
    @latLng = location.latLng
    @geocoder = `new google.maps.Geocoder()`
  end


  def location(&block)
    callback = proc do |response, status|
      block.call(response, status)
    end
    `#@geocoder.geocode({ latLng: #@latLng }, #{callback})`
  end

end

class Geocoder
  def initialize(address)
    @address = address
    @geocoder = `new google.maps.Geocoder()`
  end

  def location(&block)
    callback = proc do |response, status|
      block.call(response, status)
    end
    `#@geocoder.geocode({ address: #@address }, #{callback})`
  end
end
