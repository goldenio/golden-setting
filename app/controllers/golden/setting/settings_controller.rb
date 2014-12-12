class Golden::Setting::SettingsController < ApplicationController
  if Golden::Setting.before_actions.blank?
    raise "Please set config.before_actions like `authenticate_user!` for security."
  end
  Golden::Setting.before_actions.each do |action|
    before_filter action.to_sym
  end
  before_filter :load_setting_class, only: [:index, :create, :list, :batch_update]
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
    @setting.update_attributes setting_params
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
    end if params[:setting]
    redirect_to action: :index
  end

  protected

  def load_setting_class
    @setting_class = Golden::Setting.setting_class.constantize
  end

  def new_setting
    value = params[:setting].delete :value
    @setting = @setting_class.new setting_params
    @setting.value = value
  end

  def setting_params
    if params.respond_to? :permit
      params.require(:setting).permit(Golden::Setting.permitted_fields)
    else
      params[:setting]
    end
  end
end
