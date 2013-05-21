require 'spec_helper'

describe Golden::Setting::Base do
  let(:golden) { '#F2BE45' }
  let(:red) { '#C83C23' }
  let(:now) { Time.now }
  let(:languages) { %w(ruby html css javascript) }
  let(:cart) { {pencil: 5, rubber: 2, book: languages}  }
  let(:cart_item) { {icecream: 3} }
  let(:layout) { {'layout.color' => red, 'layout.background-color' => golden} }

  context 'Value Type' do
    it 'can deal with String value' do
      Setting.color = golden
      Setting.color.should eq golden
      Setting.color.class.should be String
    end

    it 'can deal with true value' do
      Setting.editable = true
      Setting.editable.should eq true
      Setting.editable.class.should be TrueClass
    end

    it 'can deal with false value' do
      Setting.editable = false
      Setting.editable.should eq false
      Setting.editable.class.should be FalseClass
    end

    it 'can deal with Symbol value' do
      Setting.background = :golden
      Setting.background.should eq :golden
      Setting.background.class.should be Symbol
    end

    it 'can deal with Time value' do
      Setting.booted_at = now
      Setting.booted_at.should eq now
      Setting.booted_at.class.should be Time
    end

    it 'can deal with Array value' do
      Setting.languages = languages
      Setting.languages.should eq languages
      Setting.languages.class.should be Array
    end

    it 'can deal with Hash value' do
      Setting.shopping = cart
      Setting.shopping.should eq cart
      Setting.shopping.class.should be Hash
    end
  end

  context 'Naming' do
    it 'can deal with complex name' do
      Setting['layout.color'] = red
      Setting['layout.color'].should eq red
      Setting['layout.background-color'] = golden
      Setting['layout.background-color'].should eq golden
    end
  end

  context 'Action' do
    before :each do
      Setting.destroy_all
    end

    it 'can merge hash values' do
      Setting.shopping = cart
      Setting.merge! 'shopping', cart_item
      Setting.shopping.should_not eq cart
      Setting.shopping.should eq cart.merge(cart_item)
    end

    it 'can list settings' do
      Setting.count.should eq 0
      Setting.languages = languages
      Setting['layout.color'] = red
      Setting['layout.background-color'] = golden
      Setting.count.should eq 3
      Setting.all.count.should eq 3
      Setting.list('layout.').count.should eq 2
      Setting.list('layout.').should eq layout
    end

    it 'can destory a setting' do
      Setting.languages = languages
      Setting.count.should eq 1
      Setting.destroy :languages
      Setting.languages.should eq nil
      Setting.count.should eq 0
    end
  end

  context 'Default' do
    before :each do
      Setting.destroy_all
    end

    after :each do
      Setting.defaults = {}.with_indifferent_access
    end

    it 'can deal with default value' do
      Setting.respond_to?(:defaults).should be true
      Setting.color.should eq nil
      Setting.defaults[:color] = golden
      Setting.color.should eq golden
      Setting.count.should eq 0
    end

    it 'can save default value with default group' do
      # Golden::Setting.default_group = 'theme'
      Setting.respond_to?(:save_default).should be true
      Setting.color.should eq nil
      Setting.save_default :color, golden
      Setting.named(:color).count.should eq 1
      Setting.object(:color).value.should eq golden
      Setting.object(:color).group.should eq Golden::Setting.default_group
      Setting.color.should eq golden
    end
  end
end
