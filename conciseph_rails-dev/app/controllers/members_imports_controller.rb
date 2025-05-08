# frozen_string_literal: true

class MembersImportsController < ApplicationController
  layout 'admin'
  def new
    @members_import = MembersImport.new
    render layout: 'admin'
  end

  def create
    @members_import = MembersImport.new(params[:members_import])
    if @members_import.save
      flash[:success] = 'Record was successfully created.'
      redirect_to members_path
    else
      # flash.now[:error_messages] = @members_import.errors.full_messages

      render :new, layout: 'admin'

    end
  end
end
