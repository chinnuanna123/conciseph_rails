# frozen_string_literal: true

class ApiLogsController < ApplicationController
  before_action :set_api_log, only: [:show]
  before_action :set_header
  layout 'admin'
  def index
    @api_logs = ApiLog.includes([:overseer]).where(overseer_id: params[:id]).page(params[:page] || 1).per_page(10).order('created_at DESC')
  end

  def show; end

  private

  def set_api_log
    @api_log = ApiLog.find(params[:id])
  end

  def set_header
    @header = action_name == 'index' ? 'Api Logs' : "#{action_name} Api Log"
  end
end
