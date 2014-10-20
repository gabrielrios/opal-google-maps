module Google
  class InfoWindow
    attr_reader :content

    def initialize(content = "")
      @content = content
      @native = %x{ new google.maps.InfoWindow({ content: #@content }) }
    end

    def content=(c)
      @content = c
      %x{ #@native.setContent(#@content) }
    end

    def open(map, marker)
      %x{ #@native.open(#{map.to_n}, #{marker.to_n}) }
    end
  end
end
