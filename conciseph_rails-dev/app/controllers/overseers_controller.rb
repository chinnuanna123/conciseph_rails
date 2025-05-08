# frozen_string_literal: true

class OverseersController < ApplicationController
  before_action :set_header
  before_action :set_overseer, only: %i[show edit update destroy]
  before_action :require_admin, only: %i[new create edit update destroy]
  layout 'admin'

  # GET /overseers or /overseers.json
  def index
    @overseers = Overseer.all
    respond_to do |format|
      format.html do
        @overseers = @overseers.paginate(page: params[:page], per_page: 10)
      end
    end
  end

  # GET /overseers/1 or /overseers/1.json
  # def show
  # end

  # GET /overseers/new
  def new
    @overseer = Overseer.new
  end

  # GET /overseers/1/edit
  def edit; end

  # POST /overseers or /overseers.json
  def create
    @overseer = Overseer.new(overseer_params)

    respond_to do |format|
      if @overseer.save
        format.html { redirect_to overseers_url, notice: 'Overseer was successfully created.' }
        format.json { render :show, status: :created, location: @overseer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @overseer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /overseers/1 or /overseers/1.json
  def update
    respond_to do |format|
      if @overseer.update(overseer_params)
        format.html { redirect_to overseers_url, notice: 'Overseer was successfully updated.' }
        format.json { render :show, status: :ok, location: @overseer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @overseer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /overseers/1 or /overseers/1.json
  def destroy
    @overseer.destroy

    respond_to do |format|
      format.html { redirect_to overseers_url, notice: 'Overseer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_overseer
    @overseer = Overseer.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def overseer_params
    params.require(:overseer).permit(:name, :email, :password, :password_confirmation, :role)
  end

  def require_admin
    redirect_to overseers_path, alert: 'Only admin can perform this action.' unless current_user&.is_admin
  end

  def set_header
    @header = if action_name == 'index'
                'Api Access Users Setups'
              else
                "#{action_name.titleize} Api Access Users Setup"
              end
  end
end
