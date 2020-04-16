require 'valued/mutable'
require 'valued/version'

module Valued
  module ClassMethods
    def self.normalized_attributes(attributes)
      attributes.each_with_object(attributes) do |attr, result|
        result << attr.to_s.chomp('?').to_sym if attr.to_s.end_with?('?')
      end
    end

    def self.define_method(attr, klass)
      klass.class_eval do
        if attr.to_s.end_with?('?')
          define_method(attr) do
            instance_variable_get("@#{attr.to_s.chomp('?')}")
          end
        else
          attr_reader attr
        end
      end
    end

    def attributes(*attributes)
      attributes.each { |attr| Valued::ClassMethods.define_method(attr, self) }
      define_method('_attributes') do
        Valued::ClassMethods.normalized_attributes(attributes)
      end
      private :_attributes
    end
  end

  def self.define(*attrs, &block)
    klass =
      Class.new do
        include Valued

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
        instance_variable_set(
          "@#{attribute.to_s.chomp('?')}",
          attributes.fetch(attribute).freeze
        )
      end
    end
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
      _attributes.map do |attribute|
        "#{attribute}=#{send(attribute).inspect}"
      end.join(' ')
    "#<#{self.class} #{inspected_attributes}>"
  end
end
