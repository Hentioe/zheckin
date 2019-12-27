require "schedule"

module Zheckin::Cron
  SELF_API_TOKEN  = Zheckin.get_app_env("zhihu_api_token")
  SCHEDULE_HOUR   = (Zheckin.get_app_env?("schedule_hour") || 0).to_i
  SCHEDULE_MINUTE = (Zheckin.get_app_env?("schedule_minute") || 15).to_i

  def self.init
    # 将固定的北京时间转换为本地时间
    beijing_time = Time.local(1970, 1, 1, SCHEDULE_HOUR, SCHEDULE_MINUTE, 0, location: Time::Location.load("Asia/Beijing"))
    date_time = beijing_time.to_local_in(Time.local.location)
    time_s = date_time.to_s("%H:%M:%S")

    Schedule.every(:day, time_s) { start() }
  end

  private def self.start
    # 获取个人资料并刷新圈子列表
    account = Zhihu::WrapperApi.self(SELF_API_TOKEN)
    clubs = Zhihu::WrapperApi.clubs_joined(account)
    Store.refresh_account_clubs!(account, clubs)
    # 开始签到
    Zhihu::WrapperApi.clubs_checkin_all(account)
  end
end
