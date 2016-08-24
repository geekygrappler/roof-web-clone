class DocumentStatesController < ApplicationController
  before_action :set_document_state, only: [:show, :edit, :update, :destroy]

  # GET /document_states
  # GET /document_states.json
  def index
    @document_states = DocumentState.all
  end

  # GET /document_states/1
  # GET /document_states/1.json
  def show
  end

  # GET /document_states/new
  def new
    @document_state = DocumentState.new
  end

  # GET /document_states/1/edit
  def edit
  end

  # POST /document_states
  # POST /document_states.json
  def create
    @document_state = DocumentState.new(document_state_params)

    respond_to do |format|
      if @document_state.save
        format.html { redirect_to @document_state, notice: 'Document state was successfully created.' }
        format.json { render :show, status: :created, location: @document_state }
      else
        format.html { render :new }
        format.json { render json: @document_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /document_states/1
  # PATCH/PUT /document_states/1.json
  def update
    respond_to do |format|
      if @document_state.update(document_state_params)
        format.html { redirect_to @document_state, notice: 'Document state was successfully updated.' }
        format.json { render :show, status: :ok, location: @document_state }
      else
        format.html { render :edit }
        format.json { render json: @document_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /document_states/1
  # DELETE /document_states/1.json
  def destroy
    @document_state.destroy
    respond_to do |format|
      format.html { redirect_to document_states_url, notice: 'Document state was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_document_state
    @document_state = DocumentState.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def document_state_params
    params.require(:document_state).permit(:name, :description)
  end
end
