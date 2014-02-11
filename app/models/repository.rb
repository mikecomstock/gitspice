class Repository < ActiveRecord::Base

  serialize :info
  has_many :collaborations
end
