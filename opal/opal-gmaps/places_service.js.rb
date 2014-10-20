class PlacesService
  def initialize(map)
    @map = map
    @native = %x{ new google.maps.places.PlacesService(#{@map.to_n}) }
  end

  def search(query, &callback)
    location = @map.center
    wrapper = proc {|results, status|
      callback.call(results, status)
    }.to_n

    %x{ #@native.textSearch({ query: #{query},
                              radius: #{location.radius},
                              location: #{location.latLng} }, #{wrapper}) }
  end

  def radar_search(query, &callback)
    location = @map.center
    wrapper = proc{|results, status|
      callback.call(results, status)
    }.to_n

    %x{ #@native.radarSearch({ keyword: query, location: #{location.latLng},
                               radius: #{location.radius} }, #{wrapper}) }
  end

  def get_details(place_id, &callback)
    wrapper = proc{|results, status|
      callback.call(results, status)
    }.to_n

    %x{ #@native.getDetails({ placeId: #{place_id} }, #{wrapper}) }
  end
end
