class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]
  
  has_one :address, dependent: :destroy
  has_one :card, dependent: :destroy
  has_one :sns_credential, dependent: :destroy
  has_many :items, foreign_key: "user_id"
  accepts_nested_attributes_for :address

  validates :email, format:{ with: /[a-zA-Z0-9.!#$%&_~-]+@[a-zA-Z0-9-_]+\.[a-zA-Z0-9.-]+/, message: '不正な値です。'}
  validates :nickname, :birthday, presence: true
  validates :first_name, presence: true, format: { with: /\A[ぁ-んァ-ン一-龥]/, message: 'は全角で入力して下さい。'}
  validates :last_name, presence: true, format: { with: /\A[ぁ-んァ-ン一-龥]/, message: 'は全角で入力して下さい。'}
  validates :first_name_reading, presence: true, format: { with: /\A[ァ-ヶー－]+\z/, message: 'は全角（カタカナ）で入力して下さい。'}
  validates :last_name_reading, presence: true, format: { with: /\A[ァ-ヶー－]+\z/, message: 'は全角（カタカナ）で入力して下さい。'}

  private
  def self.from_omniauth(auth_data)
    email = auth_data.info.email
    nickname = auth_data.info.name
    uid = auth_data.uid
    provider = auth_data.provider

    sns_credential = SnsCredential.where(uid: uid, provider: provider).first_or_initialize

    ## sns_credentialに紐付いたuserがいるかどうか
    if sns_credential.user.present?
      ## sns_credential.userが居るならB（SNS認証で登録した）が確定するのでここで終了
      return {user: sns_credential.user, sns_credential: sns_credential}
    else
      ## sns_credentialに紐付いたuserがいない
      ## googleから送られてきたemailでuserがヒットしたらD（メールで登録した）
      ## userがヒットしなかったらA（ユーザー登録したことがない）
      user = User.where(email: email).first_or_initialize
    end

    if user.persisted?
      ## ここにきた=D（メールで登録した）
      sns_credential.user_id = user.id
      sns_credential.save
    else
      ## ここにきた＝userもsns_credentialもヒットしなかった=A（ユーザー登録したことがない）
      user.nickname = nickname
    end

    return {user: user, sns_credential: sns_credential}
  end
end
