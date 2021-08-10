RSpec.describe Valued do
  include_examples 'a Valued', Valued

  it 'has only the explicitly defined methods' do
    expect(instance.public_methods(false)).to match_array(
      %i[unit amount custom_method]
    )
  end

  it 'does not allow to set attributes' do
    expect { instance.amount = 3 }.to raise_error(NoMethodError)
  end

  it 'does not allow mutation of values' do
    expect { instance.unit.upcase! }.to raise_error(FrozenError)
  end
end
