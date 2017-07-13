class ContactPointsController < ApplicationController
  before_action :data_check, :build_request

  ROUTE_MAP = {
    show:  proc { |params| ParliamentHelper.parliament_request.contact_points(params[:contact_point_id]) }
  }.freeze

  def show
    @contact_point = RequestHelper.filter_response_data(
      @request,
      'http://id.ukpds.org/schema/ContactPoint'
    ).first

    vcard = create_vcard(@contact_point)
    send_data vcard.to_s, filename: 'contact.vcf', disposition: 'attachment', data: { turbolink: false }
  end
end