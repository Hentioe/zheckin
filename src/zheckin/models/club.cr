module Zheckin::Model
  class Club < Jennifer::Model::Base
    with_timestamps

    mapping(
      # 圈子ID
      id: {type: String, primary: true},
      # 名字
      name: String,
      # 描述
      description: String,
      # 图标
      icon: String,
      # 背景
      background: String,

      created_at: Time?,
      updated_at: Time?,
    )

    has_many :history, History
    has_and_belongs_to_many :accounts, Account
  end
end
