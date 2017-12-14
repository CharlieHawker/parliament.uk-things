class HousesController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show:              proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.houses(params[:house_id]) },
    lookup:            proc { |params| Parliament::Utils::Helpers::ParliamentHelper.parliament_request.houses.lookup(params[:source], params[:id]) }
  }.freeze

  def show
    @house = Parliament::Utils::Helpers::RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/House'
    ).first
  end

  def lookup
    @house = @request.get.first

    redirect_to house_path(@house.graph_id)
  end
end
