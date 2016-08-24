class BackupTypesController < ApplicationController
  before_action :set_backup_type, only: [:show, :edit, :update, :destroy]

  # GET /backup_types
  # GET /backup_types.json
  def index
    @backup_types = BackupType.all
  end

  # GET /backup_types/1
  # GET /backup_types/1.json
  def show
  end

  # GET /backup_types/new
  def new
    @backup_type = BackupType.new
  end

  # GET /backup_types/1/edit
  def edit
  end

  # POST /backup_types
  # POST /backup_types.json
  def create
    @backup_type = BackupType.new(backup_type_params)

    respond_to do |format|
      if @backup_type.save
        format.html { redirect_to @backup_type, notice: 'Backup type was successfully created.' }
        format.json { render :show, status: :created, location: @backup_type }
      else
        format.html { render :new }
        format.json { render json: @backup_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /backup_types/1
  # PATCH/PUT /backup_types/1.json
  def update
    respond_to do |format|
      if @backup_type.update(backup_type_params)
        format.html { redirect_to @backup_type, notice: 'Backup type was successfully updated.' }
        format.json { render :show, status: :ok, location: @backup_type }
      else
        format.html { render :edit }
        format.json { render json: @backup_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /backup_types/1
  # DELETE /backup_types/1.json
  def destroy
    @backup_type.destroy
    respond_to do |format|
      format.html { redirect_to backup_types_url, notice: 'Backup type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_backup_type
    @backup_type = BackupType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def backup_type_params
    params.require(:backup_type).permit(:name)
  end
end
