module Zheckin::Model
  class History < Jennifer::Model::Base
    with_timestamps

    mapping(
      id: Primary32,
      msg: String,
      account_id: String,
      club_id: String,

      created_at: Time?,
      updated_at: Time?,
    )

    belongs_to :account, Account
    belongs_to :club, Club
  end
end
