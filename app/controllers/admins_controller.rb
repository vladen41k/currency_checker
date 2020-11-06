class AdminsController < ApplicationController

  def index
    @changed_rate = Redis.current.get('changed_rate')
    @date = Redis.current.get('date')

    if @date.present?
      arr = @date.split
      arr.delete_at(-1)
      arr_time = arr.delete_at(1).split(':')
      arr_time.delete_at(-1)
      arr << arr_time.join(':')
      @date = arr.join('T')
    end
  rescue Redis::CannotConnectError
    @changed_rate = 'Что-то пошло не так((('
  end

  def update
    result = UpdateRateService.new.call(admin_params)

    @result = if result.success?
                ActionCable.server.broadcast('rate', value: admin_params[:rate])
                result.success
              else
                if result.failure.try(:errors)
                  result.failure.errors.to_h.each_with_object('') { |(i, a), s| s << i.to_s + ' ' + a.join(' ') + '. ' }
                else
                  result.failure.try(:message) || result.failure
                end
              end
  end

  private

  def admin_params
    params.require(:admin).permit(:rate, :date)
  end

end
