require 'spec_helper'

describe Golden::Setting::Resource do
  let(:golden) { '#F2BE45' }
  let(:red) { '#C83C23' }
  let(:manager) { Manager.where(email: 'test@example.com').create }

  context 'Without Cache' do
    before :each do
      Setting.destroy_all
    end

    it 'can set values only belong to manager' do
      manager.settings.color = golden
      manager.settings.color.should eq golden

      manager.settings.named(:color).count.should eq 1
      Setting.count.should eq 1
      Setting.named(:color).count.should eq 0
      Setting.color = red
      Setting.named(:color).count.should eq 1
      Setting.count.should eq 2
      manager.settings.named(:color).count.should eq 1
    end

    it '#object need to #bind user first' do
      manager.settings.color = golden
      manager.settings.color.should eq golden

      Setting.color.should be nil
      Setting.object(:color).should eq nil

      # bind would cause such wrong thing
      Golden::Setting::Resource.object(:color).should_not be nil
      Golden::Setting::Resource.object(:color).value.should eq golden

      Golden::Setting::Resource.bind(manager).color.should eq golden
      Golden::Setting::Resource.bind(manager)[:color].should eq golden

      Golden::Setting::Resource.object(:color, manager).should_not be nil
      Golden::Setting::Resource.object(:color, manager).value.should eq golden

      Golden::Setting::Resource.unbind
    end

    it 'returns a scope of users having any setting' do
      pending
      User.with_settings
    end

    it 'returns a scope of users having a color setting' do
      pending
      User.with_settings_for('color')
    end

    it 'returns a scope of users having no setting at all (means user.settings.all == {})' do
      pending
      User.without_settings
    end

    it 'returns a scope of users having no color setting (means user.settings.color == nil)' do
      pending
      User.without_settings_for('color')
    end
  end

  context 'With Cache' do
    before :each do
      Setting.destroy_all
    end
  end
end
