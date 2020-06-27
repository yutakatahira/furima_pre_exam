class Users::RegistrationsController < Devise::RegistrationsController
  def select
    session.delete(:"devise.sns_auth")
    @auth_text = "で登録する"
  end

  def new
    @progress = 1

    @user = User.new(session["devise.sns_auth"]["user"]) if session["devise.sns_auth"]

    super if !session["devise.sns_auth"]
  end

  def create
    if session["devise.sns_auth"]
      pass = Devise.friendly_token[8,12]
      params[:user][:password] = pass
      params[:user][:password_confirmation] = pass
      sns = SnsCredential.new(session["devise.sns_auth"]["sns"])
    end

    build_resource(sign_up_params)
    resource.build_sns_credential(session["devise.sns_auth"]["sns_credential"]) if session["devise.sns_auth"]
    unless resource.valid?
      @progress = 1
      flash.now[:alert] = ""
      resource.errors.full_messages.each do |m|
        flash.now[:alert] << m
      end
      render :new and return
    end
    session["devise.regist_data"] = {user: @user.attributes}
    session["devise.regist_data"][:user][:password] = params[:user][:password]
    redirect_to confirm_phone_path
  end

  def confirm_phone ## userのcreateに成功したらここに来る
    @progress = 2
  end

  def pre_phone
    redirect_to new_regist_address_path
  end

  def new_address ## 電話番号認証ページのボタンを押したらここに来る
    redirect_to new_regist_payment_path if session["devise.regist_data"][:address] || current_user&.address
    @progress = 3
    @address = Address.new
  end

  def create_address
    @address = Address.new(address_params)
    if @address.valid?
      redirect_to regist_completed_path and return
    else
      @progress = 3
      flash.now[:alert] = ""
      @address.errors.full_messages.each do |m|
        flash.now[:alert] << m
      end
      render :new_address and return
    end
  end

  def completed
    redirect_to root_path, alert: "エラーが発生しました" unless session["devise.regist_data"]
    @progress = 5
    @user = build_resource(session["devise.regist_data"]["user"])
    @user.build_sns_credential(session["devise.sns_auth"]["sns_credential"]) if session["devise.sns_auth"] ## sessionがあるとき＝sns認証でここまできたとき
    @user.build_address(session["devise.regist_data"]["address"])
    if @user.save
      sign_up(resource_name, resource)
    else
      redirect_to root_path, alert: @user.errors.full_messages
    end
  end

  private

  def address_params
    params.require(:address).permit(:postal_code, :prefecture, :city, :house_number, :building_name, :phone_number)
  end

  def signed_up?
    redirect_to root_path, alert: "ログインしています。" if user_signed_in?
  end
end
