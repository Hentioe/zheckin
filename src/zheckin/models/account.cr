module Zheckin::Model
  class Account < Jennifer::Model::Base
    with_timestamps

    mapping(
      # 帐号ID
      id: {type: String, primary: true},
      # 个性域名
      url_token: String,
      # 名称
      name: String,
      # 邮箱
      email: String,
      # 头像
      avatar: String,
      # 认证令牌
      api_token: String,

      created_at: Time?,
      updated_at: Time?,
    )

    has_many :history, History
    has_and_belongs_to_many :clubs, Club
  end
end
