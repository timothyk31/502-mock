class MemberController < ApplicationController
  def index
    # Members can only see themselves
    @member = current_member
  end

  def show
    # Members can only see themselves
    @member = current_member
  end
end
