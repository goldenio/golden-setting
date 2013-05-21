class Golden::Setting::SettingsController < ApplicationController
  before_filter :authenticate_session!
  before_filter :load_setting_class, only: [:index, :create, :list]
  before_filter :new_setting, only: [:create]
  load_and_authorize_resource :setting, class: Golden::Setting.setting_class, parent: false

  respond_to :html

  def index
    @default_tab = Golden::Setting.default_tab
    respond_with @settings
  end

  def show
    respond_with @setting
  end

  def new
    respond_with @setting
  end

  def edit
  end

  def create
    @setting.save
    respond_with @setting, location: setting_path(@setting)
  end

  def update
    value = params[:setting].delete :value
    @setting.value = value
    @setting.update_attributes params[:setting]
    respond_with @setting, location: setting_path(@setting)
  end

  def destroy
    @setting.destroy
    respond_with @setting, location: settings_path
  end

  def list
    @settings = @settings.paginate page: params[:page]
    respond_with @settings
  end

  def batch_update
    params[:setting].each do |setting, value|
      @setting_class.send "#{setting}=", value
    end
    redirect_to action: :index
  end

  protected

  def load_setting_class
    @setting_class = Golden::Setting.setting_class.constantize
  end

  def new_setting
    value = params[:setting].delete :value
    @setting = @setting_class.new params[:setting]
    @setting.value = value
  end
end
