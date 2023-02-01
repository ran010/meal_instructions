class CommandsController < ApplicationController
  def create
    @command = current_user.commands.build(
      attachments: command_params[:attachments]
    )
    @command.save
  end

  private

  def command_params
    params.require(:command).permit(attachments: [])
  end
end
