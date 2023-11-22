class Report < ApplicationRecord
  belongs_to :user
  validates :partner, presence: { of: :partner, message: "must be present" }
  validates :user_id, presence: true
  after_create_commit do
    u = User.find_by(id: user_id)
    p = u.point + 1
    create_broadcast
    u.update(point: p)
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "partner", "updated_at", "user_id", "name"]
  end

  private

  def create_broadcast
    broadcast_prepend_to 'report-list', partial: 'reports/report', locals: { report: self }, target: 'report-list'
    broadcast_prepend_to "u#{ self.user.id }report-list", partial: 'reports/report', locals: { report: self }, target: "u{ self.user.id }report-list"
  end
end
