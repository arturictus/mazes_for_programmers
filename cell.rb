require 'distances'

class Cell

  attr_reader :row, :column
  attr_accessor :north, :south, :east, :west

  def initialize(row, column)
    @row, @column = row, column
    @links = {}
  end

  def link(cell, bidi = true)
    @links[cell] = true
    cell.link(self, false) if bidi
    self
  end


  def unlink(cell, bidi = true)
    @links.delete(cell)
    cell.unlink(self, false) if bidi
    self
  end

  def links
    @links.keys
  end


  def linked?(cell)
    @links.key?(cell)
  end

  def neighbors
    list = []
    list << north if north
    list << south if south
    list << east  if east
    list << west  if west
    list
  end

  def distances
    distances = Distances.new(self)
    frontier = [ self ]
    # keep looping until there are no more cells in the frontier set
    while frontier.any?
      # hold all of the unvisited cells that are linked to cells in the current frontier set
      new_frontier = []
      # populate that new_frontier by iterating over the frontier cells, 
      # and considering every neighbor that is linked to them.
      frontier.each do |cell|
        cell.links.each do |linked|
          next if distances[linked]
          distances[linked] = distances[cell] + 1
          new_frontier << linked
        end
      end
      frontier = new_frontier
    end

    distances
  end
end
