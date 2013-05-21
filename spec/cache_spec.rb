require 'spec_helper'

describe 'Golden::Setting::Base with Cache' do
  let(:golden) { '#F2BE45' }
  let(:red) { '#C83C23' }

  context 'Default' do
    before :each do
      CachedSetting.destroy_all
      Rails.cache.clear
    end

    after :each do
      CachedSetting.defaults = {}.with_indifferent_access
    end

    it 'can use default value, while cached value of setting is nil' do
      CachedSetting.respond_to?(:defaults).should be true
      CachedSetting.color.should eq nil
      CachedSetting.defaults[:color] = golden
      CachedSetting.color.should eq golden
      CachedSetting.count.should eq 0
    end

    it 'can save default values, while cached value of setting is nil' do
      CachedSetting.respond_to?(:save_default).should be true
      CachedSetting.named(:color).count.should eq 0
      CachedSetting.color.should be nil

      CachedSetting.save_default :color, red
      CachedSetting.named(:color).count.should eq 1
      CachedSetting.object(:color).value.should eq red
      CachedSetting.color.should eq red

      CachedSetting.save_default :color, golden
      CachedSetting.object(:color).value.should eq red
      CachedSetting.color.should eq red
    end
  end
end
