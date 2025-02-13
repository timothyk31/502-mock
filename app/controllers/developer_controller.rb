# frozen_string_literal: true

class DeveloperController < ApplicationController
  before_action :authenticate_dev!

  def index
    @members = Member.all
  end

  def show
    @members = Member.all
  end

  def update_roles
    params[:members].each do |id, role|
      member = Member.find(id)
      member.update(role: role)
    end
    redirect_to developer_index_path, notice: 'Roles updated successfully.'
  end

  private

  def authenticate_dev!
    return if current_member.email == ENV['DEV_EMAIL']

    redirect_to root_path, alert: 'You are not authorized to view this page.'
  end
end
