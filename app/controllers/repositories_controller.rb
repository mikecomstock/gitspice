class RepositoriesController < ApplicationController
  def show
    full_name = "#{params[:login]}/#{params[:repo]}"
    @client = Octokit::Client.new :access_token => current_user.oauth_token
    @repo = @client.repo full_name
    #@tree = @client.tree full_name, @repo.default_branch
    #TODO: sort contents
    @contents = @client.contents full_name, :path => params[:content_path]
    @commits = @client.commits full_name, { :path => params[:content_path] }
    @branches = []# @client.branches full_name

    #debugger
  end
end
