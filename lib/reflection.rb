module Plant
  module Reflection
    @@reflections = {}
    
    def self.reflect klass
      return if @@reflections[klass]
      associations = lambda {|klass, macro| klass.reflect_on_all_associations(macro).map{|association| association.name} || []}

      reflection = @@reflections[klass] = Hash.new
      [:has_many, :has_one, :belongs_to].each {|relation| reflection[relation] = associations.call(klass, relation)}
      reflection[:attributes] = klass.new.attributes
    end
    
    def self.clone object, id
      clone = object.class.new
      cloner = Proc.new {|attribute| clone.send(attribute.to_s + "=", object.send(attribute))}
      reflection = @@reflections[object.class]
      
      reflection[:attributes].keys.each(&cloner)
      [:has_many, :has_one, :belongs_to].each {|relation| reflection[relation].each(&cloner)}

      clone.id = id
      clone
    end
    
    def self.has_many_association? klass, method
      @@reflections[klass][:has_many].include?(method)
    end

    def self.has_one_association? klass, method
      @@reflections[klass][:has_one].include?(method)
      
    end

    def self.foreign_key object, association
      object.class.name.underscore + '_id'
    end
    
  end
end