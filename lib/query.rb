module Plant
  module Query

    @@wheres = nil

    def self.wheres= wheres
      @@wheres = wheres
    end

    def self.wheres
      @@wheres
    end

    def self.find_all klass
      Plant.all[klass] || []
    end

    def self.find_by_ids klass, ids
      plants = Plant.all[klass].select{|plant| ids.include?(plant.id)}
      return plants.first if plants.size == 1
      plants
    end

    def self.select klass
      Plant::Selector.new(:klass => klass, :wheres => @@wheres, :plants => Plant.all[klass].to_a).select
    end

    def self.order objects, args
      attribute, order = args.split(" ")
      objects.sort {|x, y| (x,y = y,x if order == 'desc'); x.send(attribute.to_sym) <=> y.send(attribute.to_sym)}
    end

    def self.limit objects, limit_value
      @@objects = objects
      @@limit = limit_value
      objects.first(limit_value)
    end
    
    def self.offset objects, offset_value
      @@objects[offset_value..-1].first(@@limit)
    end

  end
end
