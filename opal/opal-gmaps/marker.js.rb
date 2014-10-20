module Google
  class Marker
    attr_accessor :title, :location, :map

    def initialize(title, location, color = 'FA5F4F', draggable = false)
      @title = title.to_s
      @location = location
      @icon = "http://www.googlemapsmarkers.com/v1/#{color}"
      @zindex = 1

      @native = %x{ new google.maps.Marker({ position: #{@location.to_n},
                                            title: #@title,
                                            draggable: #{@draggable.to_n},
                                            zindex: #@zindex,
                                            icon: #@icon }) }
    end

    def map=(m)
      @map = m
      %x{#@native.setMap(#{@map.to_n})}
    end

    def location=(l)
      @location = l
      %x{ #@native.setPosition(#{@location.to_n}) }
    end

    def on(type, &callback)
      wrapper = proc{|event|
        callback.call(Native(event))
      }.to_n

      %x{ google.maps.event.addListener(#@native, #{type}, #{wrapper}) }
    end

    def off(type)
      %x{ google.maps.event.clearListeners(#@native, #{type}); }
    end

    def to_n
      @native
    end

    def ==(other)
      self.location == other.location && title == title
    end

    def !=(other)
      !(self == other)
    end

    def to_s
      "#<GMap::Marker title='#{title}' location='#{location}'>"
    end
  end

  class CenterMarker < Marker
    def initialize(location)
      super(nil, location, '009900', false)
    end
  end
end
