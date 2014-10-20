module Google
  class Map
    def initialize(div, map_type = 'hybrid',  options = {})
      @div = div
      @options = options.merge({ streetViewControl: false, zoom: 10 })
      @native = %x{ new google.maps.Map(#@div, #{@options.to_n}) }
      @markers = []
    end

    def on(type, &callback)
      wrapper = proc{|event|
        callback.call(Native(event))
      }.to_n

      %x{ google.maps.event.addListener(#@native, #{type}, #{wrapper}) }
    end

    # TODO: test
    def center
      Google::Location.from_native(%x{#@native.getCenter()})
    end

    def center=(location)
      if location.is_a?(Marker)
        location.map = self
        location = location.location
      end
      %x{ #@native.setCenter(#{location.to_n}) }
    end

    def to_n
      @native
    end

    def add_marker(marker)
      @markers << marker
    end

    def create_marker(title, location)
      marker = Marker.new(title, location)
      if !@markers.include?(marker)
        marker.map = self
        @markers << marker
        marker
      end

      marker
    end

    def map_type
      %x{ #@native.getMapTypeId() }
    end
  end
end

# class Map
#   attr_accessor :map, :infoWindow
#   attr_reader :center

#   def initialize(css_selector)
#     @bounds = MapBounds.new
#     @map = %x{ new google.maps.Map($(#{css_selector})[0], { streetViewControl: false, zoom: 10, mapTypeId: #{map_type} }) }

#     $window.on :resize do
#       %x{ google.maps.event.trigger(#@map, 'resize') }
#       set_center(@center)
#       bounds_to_radius
#     end

#     @infoWindow =  %x{ new google.maps.InfoWindow() }

#     `google.maps.event.addListener(#@map,  'dragend',            #{handle_drag})`
#     `google.maps.event.addListener(#@map,  'dblclick',           #{handle_double_click})`
#     `google.maps.event.addListener(#@map,  'click',              #{handle_double_click})`
#     `google.maps.event.addListener(#@map,  'maptypeid_changed',  #{update_user_maptype})`
#   end

#   def update_user_maptype
#     proc do
#       Element['meta[name=map_type]']['content'] = %x{#@map.getMapTypeId()}
#       HTTP.put("/account/map_type?type=" + %x{ #@map.getMapTypeId() })
#     end
#   end

#   def map_type
#     case Element['meta[name=map_type]']['content']
#     when 'hybrid'
#       %x{google.maps.MapTypeId.HYBRID}
#     when 'roadmap'
#       %x{google.maps.MapTypeId.ROADMAP}
#     when 'satellite'
#       %x{google.maps.MapTypeId.SATELLITE}
#     # when 'terrain'
#     else
#       %x{google.maps.MapTypeId.TERRAIN}
#     end
#   end

#   def add_coordinates(location)
#     if location.valid?
#       @bounds.add(location) if !include_location?(location)
#     end
#   end

#   def build
#     plot_venues
#     bounds_to_radius
#   end

#   def location=(location)
#     @location = location
#     set_center(location)
#   end

#   def set_center(center)
#     @center = center
#     %x{ #@map.setCenter(#@center.latLng) }
#   end

#   def update_center
#     %x{ #@map.setCenter(#@center.latLng) }
#   end

#   def handle_double_click
#     proc do |event|
#       @center.latLng = `event.latLng`
#       update_center
#       update_venues
#     end
#   end

#   def handle_drag
#     proc do
#       @center.latLng = `#@map.getCenter()`
#       update_center
#       update_venues
#     end
#   end

#   def update_venues
#     HTTP.get "/venues/near?l=#@center&r=#{@center.radius}" do |response|
#       response.json.each do |location|
#         lobj = Venue.new_from_hash(location["post"])
#         @bounds.add(lobj) if !include_location?(lobj)
#       end
#       plot_venues
#     end
#   end

#   def include_location?(location)
#     (@location && @location == location) || @bounds.include?(location)
#   end

#   def plot_venues
#     @bounds.venues.each do |location|
#       location.plot(self)
#     end
#   end

#   def unplot_venues
#     @bounds.venus.each(&:unplot)
#   end

#   def bounds_to_radius
#     `#@circle.setMap(null)` if @circle
#     @circle = %x{ new google.maps.Circle({
#                             center: #{@center.latLng},
#                             radius: #{@center.radius.to_f * 1609.344},
#                             strokeColor: "#0000FF",
#                             strokeOpacity: 0,
#                             strokeWeight: 2,
#                             fillColor: "#0000FF",
#                             fillOpacity: 0,
#                             map: #@map
#                         });
#                 }

#     %x{ #@map.fitBounds(#@circle.getBounds()); }
#   end

#   def to_n
#     @map
#   end
# end
