module Zheckin::Model
  class History < Jennifer::Model::Base
    with_timestamps

    JSON.mapping(
      id: Int32,
      msg: String,
      account_id: String,
      club_id: String,
      created_at: Time?,
      updated_at: Time?
    )

    mapping(
      id: Primary32,
      # 结果消息
      msg: String,
      # 所属帐号
      account_id: String,
      # 所属圈子
      club_id: String,

      created_at: Time?,
      updated_at: Time?,
    )

    belongs_to :account, Account
    belongs_to :club, Club
  end
end
