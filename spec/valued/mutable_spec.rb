require 'valued/mutable'

RSpec.describe Valued::Mutable do
  context 'when defining a quantity value object' do
    let(:quantity_class) do
      Class.new do
        include Valued::Mutable

        attributes :unit, :amount

        def custom_method
          :custom_method
        end
      end
    end

    let(:instance) { quantity_class.new(unit: 'm', amount: 2) }
    let(:duck_type) { Struct.new(:unit, :amount) }
    let(:duck_object) { duck_type.new('m', 2) }

    it 'defines an initializer and sets defined attributes' do
      expect(instance.amount).to eq(2)
      expect(instance.unit).to eq('m')
    end

    it 'has only the explicitly defined methods' do
      expect(instance.public_methods(false)).to match_array(
        %i[unit unit= amount amount= custom_method]
      )
    end

    it 'allows attributes with question marks' do
      klass = Valued::Mutable.define(:valid?)
      instance = klass.new(valid?: true)

      expect(instance.valid?).to eq(true)
    end

    it 'allows omitting the question mark on initialization' do
      klass = Valued::Mutable.define(:valid?)
      instance = klass.new(valid: true)

      expect(instance.valid?).to eq(true)
    end

    it 'defines setter for attributes with question marks' do
      klass = Valued::Mutable.define(:valid?)
      instance = klass.new(valid?: true)
      instance.valid = false

      expect(instance.valid?).to eq(false)
    end

    it 'can be initialized without params' do
      empty_instance = quantity_class.new
      expect(empty_instance.unit).to eq(nil)
      expect(empty_instance.amount).to eq(nil)
    end

    it 'sets a value to nil if omitted in construction' do
      quantity = quantity_class.new(amount: 1)

      expect(quantity.unit).to eq(nil)
    end

    it 'does allow to set attributes' do
      instance.amount = 3
      expect(instance.amount).to eq(3)
    end

    it 'does allow mutation of values' do
      instance.unit.upcase!
      expect(instance.unit).to eq('M')
    end

    it 'does not allow to set arbitrary attributes on construction' do
      expect(instance.instance_variable_get('@moep')).to be_nil
      expect { instance.moep }.to raise_error(NoMethodError)
    end

    it 'equals another instance when values are equal' do
      instance_one = quantity_class.new(unit: 'm', amount: 2)
      instance_two = quantity_class.new(unit: 'm', amount: 2)
      instance_three = quantity_class.new(unit: 'm', amount: 3)

      expect(instance_one == instance_two).to eq(true)
      expect(instance_two == instance_three).to eq(false)
      expect(instance_one == instance_three).to eq(false)
    end

    it 'equals another object when the duck type matches' do
      expect(instance == duck_object).to eq(true)
    end

    it 'does not raise when comparing to an arbitrary type' do
      expect { instance == 1 }.not_to raise_error
    end

    it 'can be converted to a hash' do
      expect(instance.to_h).to eq({ unit: 'm', amount: 2 })
    end

    it 'can construct itself with the hash it converts to' do
      expect(quantity_class.new(instance.to_h)).to eq(instance)
    end

    it 'can be used as a hash key' do
      hash = { quantity_class.new(instance.to_h) => 1 }

      expect(hash[instance]).to eq(1)
    end

    it 'only equals a hash key if the class is the same' do
      hash = { quantity_class.new(instance.to_h) => 1, duck_object => 2 }

      expect(hash[instance]).to eq(1)
    end

    it 'implements to_s with inspect' do
      expect(instance.to_s).to eq(instance.inspect)
    end

    it 'prints a proper inspect output' do
      allow(instance).to receive(:class).and_return('Quantity')
      expect(instance.inspect).to eq('#<Quantity unit="m" amount=2>')
    end

    it 'allows defining of custom methods' do
      expect(instance.custom_method).to eq(:custom_method)
    end
  end

  describe '#define' do
    let(:quantity_class) do
      Valued::Mutable.define(:unit, :amount) do
        def custom_method
          :custom_method
        end
      end
    end

    let(:instance) { quantity_class.new(unit: 'm', amount: 2) }

    it 'defines an initializer and sets defined attributes' do
      expect(instance.amount).to eq(2)
      expect(instance.unit).to eq('m')
    end

    it 'can be initialized without params' do
      empty_instance = quantity_class.new
      expect(empty_instance.unit).to eq(nil)
      expect(empty_instance.amount).to eq(nil)
    end

    it 'sets a value to nil if omitted in construction' do
      quantity = quantity_class.new(amount: 1)

      expect(quantity.unit).to eq(nil)
    end

    it 'allows defining of custom methods' do
      expect(instance.custom_method).to eq(:custom_method)
    end
  end
end
