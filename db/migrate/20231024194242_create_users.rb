class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email,           null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone, null: false
      t.date :active_date
      t.date :expired_date

      t.boolean :verified, null: false, default: false

      t.boolean :otp_required_for_sign_in, null: false, default: false
      t.string  :otp_secret, null: false

      t.string :provider
      t.string :uid

      t.timestamps
    end
  end
end
