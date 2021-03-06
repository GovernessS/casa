class ImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :must_be_admin

  def index; end

  def create
    check_empty_attachment
    import = import_from_csv(params[:import_type], params[:file], current_user.casa_org_id)
    flash[import[:type]] = import[:message]
    redirect_to imports_path
  end

  private

  def import_from_csv(import_type, file, org)
    case import_type
    when "volunteer"
      FileImporter.new(file, org).import_volunteers
    when "supervisor"
      FileImporter.new(file, org).import_supervisors
    when "casa_case"
      FileImporter.new(file, org).import_cases
    else
      { type: :error, message: "Something went wrong with the import, did you attach a csv file?" }
    end
  end

  def check_empty_attachment
    return unless params[:file].blank?
    flash[:error] = 'You must attach a csv file in order to import information!'
    redirect_to imports_path
  end
end
