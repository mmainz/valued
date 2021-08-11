module Valued
  module Mutable
    module ClassMethods
      def attributes(*attributes)
        attributes.each do |attribute|
          self.class_eval { attr_accessor attribute }
        end
        define_method('_attributes') { attributes }
        private :_attributes
      end
    end

    def self.define(*attrs, &block)
      klass =
        Class.new do
          include Valued::Mutable

          attributes(*attrs)
        end
      klass.class_eval(&block) if block_given?
      klass
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    def initialize(attributes = {})
      _attributes.each do |attribute|
        if attributes.key?(attribute)
          instance_variable_set("@#{attribute}", attributes.fetch(attribute))
        end
      end
    end

    def update(new_attributes)
      self.class.new(
        _attributes.each_with_object({}) do |attribute, result|
          result[attribute] = new_attributes[attribute] || self.send(attribute)
        end
      )
    end

    def ==(other)
      _attributes.all? do |attribute|
        other.respond_to?(attribute) && send(attribute) == other.send(attribute)
      end
    end

    def eql?(other)
      self.class == other.class && self == other
    end

    def hash
      (_attributes.map { |attribute| send(attribute) } + [self.class]).hash
    end

    def to_h
      _attributes.each_with_object({}) do |attribute, hash|
        hash[attribute] = send(attribute)
      end
    end

    def to_s
      inspect
    end

    def inspect
      inspected_attributes =
        _attributes
          .map { |attribute| "#{attribute}=#{send(attribute).inspect}" }
          .join(' ')
      "#<#{self.class} #{inspected_attributes}>"
    end
  end
end
