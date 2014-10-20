class MapBounds
  attr_reader :google_bounds, :venues
  def initialize
    @venues = []
  end

  def add(location)
    @venues.push(location)
  end

  def include?(location)
    @venues.include?(location)
  end

  def inspect
    "#<MapBounds: venues_count: #{@venues.size}>"
  end

end

