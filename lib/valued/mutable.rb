module Valued
  module Mutable
    include Valued

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
  end
end
