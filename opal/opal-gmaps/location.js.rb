module Google
  class Location
    include Native

    alias_native :latitude, :lat
    alias_native :longitude, :lng

    attr_accessor :native

    def initialize(latitude, longitude)
      if latitude && longitude
        @native = %x{ new google.maps.LatLng(#{latitude}, #{longitude}) }
      end
    end

    def self.from_native(native)
      ll = new(nil, nil)
      ll.native = native
      ll
    end

    def to_n
      @native
    end

    def to_s
      "#{latitude},#{longitude}"
    end

    def ==(other)
      self.latitude == self.latitude && other.longitude == self.longitude
    end

    def !=(other)
      !(self == other)
    end

  end
end
