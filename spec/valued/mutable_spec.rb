require 'valued/mutable'

RSpec.describe Valued::Mutable do
  include_examples 'a Valued', Valued::Mutable

  it 'has only the explicitly defined methods' do
    expect(instance.public_methods(false)).to match_array(
      %i[unit unit= amount amount= custom_method]
    )
  end

  it 'does allow to set attributes' do
    instance.amount = 3
    expect(instance.amount).to eq(3)
  end

  it 'does allow mutation of values' do
    instance.unit.upcase!
    expect(instance.unit).to eq('M')
  end
end
