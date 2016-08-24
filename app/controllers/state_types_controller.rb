class StateTypesController < ApplicationController
  before_action :set_state_type, only: [:show, :edit, :update, :destroy]

  # GET /state_types
  # GET /state_types.json
  def index
    @state_types = StateType.all
  end

  # GET /state_types/1
  # GET /state_types/1.json
  def show
  end

  # GET /state_types/new
  def new
    @state_type = StateType.new
  end

  # GET /state_types/1/edit
  def edit
  end

  # POST /state_types
  # POST /state_types.json
  def create
    @state_type = StateType.new(state_type_params)

    respond_to do |format|
      if @state_type.save
        format.html { redirect_to @state_type, notice: 'State type was successfully created.' }
        format.json { render :show, status: :created, location: @state_type }
      else
        format.html { render :new }
        format.json { render json: @state_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /state_types/1
  # PATCH/PUT /state_types/1.json
  def update
    respond_to do |format|
      if @state_type.update(state_type_params)
        format.html { redirect_to @state_type, notice: 'State type was successfully updated.' }
        format.json { render :show, status: :ok, location: @state_type }
      else
        format.html { render :edit }
        format.json { render json: @state_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /state_types/1
  # DELETE /state_types/1.json
  def destroy
    @state_type.destroy
    respond_to do |format|
      format.html { redirect_to state_types_url, notice: 'State type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_state_type
    @state_type = StateType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def state_type_params
    params.require(:state_type).permit(:name, :metric, :calculation, :description)
  end
end
