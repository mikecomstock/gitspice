class User < ActiveRecord::Base

  serialize :info

  def to_param
    name
  end

  def self.create_with_omniauth(auth)
    puts 'create_with_omniauth'
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
    end
  end

  def update_from_omniauth_github!(auth)
    puts 'update_from_omniauth'
    self.oauth_token = auth['credentials']['token']
    self.name = auth['info']['nickname']
    self.info = auth
    self.save
    update_repositories
  end

  def repos
    client = Octokit::Client.new :access_token => self.oauth_token
    client.repos
  end

  # This takes a while, should do it in the background instead.
  def update_repositories
    client = Octokit::Client.new :access_token => self.oauth_token
    client.repos.each do |repo|
      r = Repository.find_or_initialize_by full_name: repo.full_name
      r.update info: repo
      r.save
    end
  end

end

#<OmniAuth::AuthHash
#credentials=#<OmniAuth::AuthHash
#expires=false
#token="12345">
#extra=#<OmniAuth::AuthHash
#raw_info=#<OmniAuth::AuthHash
#avatar_url="https://2.gravatar.com/avatar/d5d32ifD32k4602fd91sj3k2327P346?d=https%3A%2F%2Fidenticons.github.com%2F79528e7b2ce7f40ebc72c9829c0479ea.png&r=x"
#collaborators=3
#created_at="2011-02-10T19:01:09Z"
#disk_usage=796
#events_url=
#"https://api.github.com/users/mikecomstock/events{/privacy}"
#followers=4
#followers_url="https://api.github.com/users/mikecomstock/followers"
#following=7
#following_url="https://api.github.com/users/mikecomstock/following{/other_user}"
#gists_url="https://api.github.com/users/mikecomstock/gists{/gist_id}"
#gravatar_id="5639b6ff37471b7d5460227f749384a6"
#html_url="https://github.com/mikecomstock"
#id=611456
#login="mikecomstock"
#organizations_url="https://api.github.com/users/mikecomstock/orgs"
#owned_private_repos=4
#plan=#<OmniAuth::AuthHash
#collaborators=1
#name="micro"
#private_repos=5
#space=614400>
#private_gists
#=0
#public_gists=4
#public_repos=6
#received_events_url="https://api.github.com/users/mikecomstock/received_events"
#repos_url="https://api.github.com/users/mikecomstock/repos"
#site_admin=false
#starred_url="https://api.github.com/users/mikecomstock/starred{/owner}{/repo}"
#subscriptions_url="https://api.github.com/users/mikecomstock/subscriptions"
#total_private_repos=5
#type="User"
#updated_at="2013-12-01T00:39:12Z"
#url="https://api.github.com/users/mikecomstock">>
#
#info=#<OmniAuth::AuthHash::InfoHash
#email="mikecomstock@gmail.com"
#image="https://2.gravatar.com/avatar/5639b6ff37471b7d5460227f749384a6?d=https%3A%2F%2Fidenticons.github.com%2F79528e7b2ce7f40ebc72c9829c0479ea.png&r=x" 
#name=nil 
#nickname="mikecomstock" 
#urls=#<OmniAuth::AuthHash
#Blog=nil
#GitHub="https://github.com/mikecomstock">>
#provider="github"
#uid="611456">/
