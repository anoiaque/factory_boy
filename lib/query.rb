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

    def self.limit objects, args
      objects.first(args)
    end
    
  end
end