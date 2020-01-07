require "schedule"

module Zheckin::Cron
  SELF_API_TOKEN  = Zheckin.get_app_env("zhihu_api_token")
  SCHEDULE_HOUR   = (Zheckin.get_app_env?("schedule_hour") || 0).to_i
  SCHEDULE_MINUTE = (Zheckin.get_app_env?("schedule_minute") || 15).to_i

  def self.init
    time = Time.local(1970, 1, 1, SCHEDULE_HOUR, SCHEDULE_MINUTE, 0)
    time_s = time.to_s("%H:%M:%S")

    Logging.info "scheduling time: #{time_s}"

    Schedule.every(:day, time_s) { start() }
  end

  private def self.start
    Logging.info "checkin started"

    Store.find_accounts(enabled: true).each do |account|
      begin
        # 开始签到
        Zhihu::WrapperApi.clubs_checkin_all(account)
      rescue e
        Logging.error e.message || e.to_s
      end
    end

    Logging.info "checkin done"
  end
end
