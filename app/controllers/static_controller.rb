class StaticController < ApplicationController
  def index
    @command = current_user.commands.new if current_user.present?
  end
end
