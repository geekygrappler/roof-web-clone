class ResourceController < ApiController
  include CanCan::ControllerAdditions
  include Pagination

  before_filter :auth_xhr!
  before_filter :set_record, except: [:new, :create, :index]
  before_filter :set_records, only: [:index]
  before_action :authorize_record!

  rescue_from CanCan::AccessDenied do |exception|
    head :forbidden
  end

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    head 412
  end

  def self.model_name
    @model_name ||= self.name.demodulize.gsub(/Controller/,'').classify
  end

  def self.model model = nil
    @model ||= model || model_name.constantize
  end

  def self.serializer
    "#{model_name}Serializer".constantize rescue nil
  end

  def new
    @record = self.class.model.new
    render json: @record, serializer: serializer
  end

  def create
    @record = self.class.model.new(permitted_params)
    authorize_record!
    render(@record.save ? record_response(:created) : errors_response)
  end

  def show
    render json: @record, serializer: serializer
  end

  def index
    meta = {
      :current_page => current_page,
      :total_pages => total_pages,
      :pager_start => pager_start(limit),
      :pager_end => pager_end(limit),
      :has_next_page => has_next_page?(limit),
      :has_previous_page => has_previous_page?(limit)
    }
    @records = paginated_records if (params[:page] || params[:offset] || params[:limit])
    if params[:count]
      render json: {count: @records.count}, adapter: :json, each_serializer: serializer, meta: meta
    else
      render json: @records, adapter: :json, each_serializer: serializer, meta: meta
    end
  end

  def update
    if @record.update(permitted_params)
      head :no_content
    else
      render(errors_response)
    end
  end

  def destroy
    if @record.destroy
      head :no_content
    else
      render(errors_response)
    end
  end

  protected

  def set_record
    @record = self.class.model.find(params[:id])
  end

  def set_records
    @records = self.class.model.accessible_by(current_ability)
    @records = @records.search(params[:query]) if params[:query]
    # @records = paginated_records if (params[:page] || params[:offset] || params[:limit])
    @records = @records.where(id: params[:id]) if params[:id]
    @records = @records.order("#{params[:order][0]} #{params[:order][1]}") if params[:order]
    @records
  end

  def permitted_params
    @permitted_params ||= params.require(self.class.model_name.underscore).permit(permitted_attributes)
  end

  def permitted_attributes; end

  private

  def record_response status = :success
    {json: @record, status: status, serializer: serializer}
  end

  def errors_response
    {json: @record.errors, status: :unprocessable_entity}
  end

  def authorize_record!
    authorize!(params[:action].to_sym, @record || self.class.model)
  end

  private

  def current_ability
    @current_ability ||= Ability.new(current_user, params[:action].to_sym)
  end

  def serializer
    if params[:serializer]
      [params[:serializer].capitalize, 'Serializer'].join.constantize rescue self.class.serializer
    else
      "#{self.class.model_name}#{params[:action].to_s.classify}Serializer".constantize rescue self.class.serializer
    end
  end

end
