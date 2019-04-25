module SessionSupport
  
  def login(user)
    visit login_path
    fill_in t('activerecord.attributes.user.email'), with: user.email
    fill_in t('activerecord.attributes.user.password'), with: user.password
    click_on t('buttons.login')
  end

  def logout
    click_on t('links.sessions.destroy')
  end
end
