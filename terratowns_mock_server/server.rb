=begin
The require 'sinatra' statement loads the Sinatra web framework, require 'json' loads the JSON library, 
require 'pry' loads the Pry debugging tool, and require 'active_model' loads the Active Model framework, 
all for use in your Ruby application.
=end
require 'sinatra'
require 'json'
require 'pry'
require 'active_model'

# Setting a global variable. You would never use a global variable in production server.
$home = {}

=begin
The Home class defines the structure and validation rules for a home object, with attributes like town, name,
description, domain_name, and content_version. It includes ActiveModel::Validations to enforce data integrity and validation.
=end

class Home
  include ActiveModel::Validations
  attr_accessor :town, :name, :description, :domain_name, :content_version

  validates :town, presence: true
  validates :name, presence: true
  validates :description, presence: true
  validates :domain_name, 
    format: { with: /\.cloudfront\.net\z/, message: "domain must be from .cloudfront.net" }
    # uniqueness: true, 

  validates :content_version, numericality: { only_integer: true }
end

class TerraTownsMockServer < Sinatra::Base

  def error code, message
    halt code, {'Content-Type' => 'application/json'}, {err: message}.to_json
  end

  def error_json json
    halt code, {'Content-Type' => 'application/json'}, json
  end

  def ensure_correct_headings
    unless request.env["CONTENT_TYPE"] == "application/json"
      error 415, "expected Content_type header to be application/json"
    end

    unless request.env["HTTP_ACCEPT"] == "application/json"
      error 406, "expected Accept header to be application/json"
    end
  end
  # return a harcoded access token
  def x_access_code
    return '9b49b3fb-b8e9-483c-b703-97ba88eef8e0'
  end

  def x_user_uuid
    return 'e328f4ab-b99f-421c-84c9-4ccea042c7d1'
  end

  def find_user_by_bearer_token
    # https://swagger.io/docs/specification/authentication/bearer-authentication/
    auth_header = request.env["HTTP_AUTHORIZATION"]
    # Check if the Authorization header exists? 
    if auth_header.nil? || !auth_header.start_with?("Bearer ")
      error 401, "a1000 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

=begin
    Does the token match the one in our database? If we cant find it then return an error or if it doesn't match
    code = access_code = token
=end
    code = auth_header.split("Bearer ")[1]
    if code != x_access_code
      error 401, "a1001 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

# was there a user_uuid in the body payload json?
    if params['user_uuid'].nil?
      error 401, "a1002 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

# the code and the user_uuid should be matching for user
    unless code == x_access_code && params['user_uuid'] == x_user_uuid
      error 401, "a1003 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end
  end

  # CREATE
  post '/api/u/:user_uuid/homes' do
    ensure_correct_headings()
    find_user_by_bearer_token()
    # puts will print to the terminal similar to a print or console.log
    puts "# create - POST /api/homes"

    begin
    # Sinatra does not automatically parse json bodys as params like rails so we need to manually parse it.
      payload = JSON.parse(request.body.read)
    rescue JSON::ParserError
      halt 422, "Malformed JSON"
    end

    # Assign the payload to variables to make easier to work with the code
    name = payload["name"]
    description = payload["description"]
    domain_name = payload["domain_name"]
    content_version = payload["content_version"]
    town = payload["town"]

    #printing the variables out to console to make it eaiser to see or debug what we have inputed into this endpoint
    puts "name #{name}"
    puts "description #{description}"
    puts "domain_name #{domain_name}"
    puts "content_version #{content_version}"
    puts "town #{town}"

    # Create a new Home model and set to attributes
    home = Home.new
    home.town = town
    home.name = name
    home.description = description
    home.domain_name = domain_name
    home.content_version = content_version
    
# ensure our validation checks pass otherwise return the errors
    unless home.valid?
      error 422, home.errors.messages.to_json
    end

# generating a uuid at random.
    uuid = SecureRandom.uuid
    puts "uuid #{uuid}"
    $home = {
      uuid: uuid,
      name: name,
      town: town,
      description: description,
      domain_name: domain_name,
      content_version: content_version
    }
# will just return uuid
    return { uuid: uuid }.to_json
  end

  # READ
  get '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# read - GET /api/homes/:uuid"

    # checks for house limit

    content_type :json
    if params[:uuid] == $home[:uuid]
      return $home.to_json
    else
      error 404, "failed to find home with provided uuid and bearer token"
    end
  end

  # UPDATE - Similar to CREATE
  put '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# update - PUT /api/homes/:uuid"
    begin
      # Parse JSON payload from the request body
      payload = JSON.parse(request.body.read)
    rescue JSON::ParserError
      halt 422, "Malformed JSON"
    end

    # Validate payload data
    name = payload["name"]
    description = payload["description"]
    content_version = payload["content_version"]

    unless params[:uuid] == $home[:uuid]
      error 404, "failed to find home with provided uuid and bearer token"
    end

    home = Home.new
    home.town = $home[:town]
    home.domain_name = $home[:domain_name]
    home.name = name
    home.description = description
    home.content_version = content_version

    unless home.valid?
      error 422, home.errors.messages.to_json
    end

    return { uuid: params[:uuid] }.to_json
  end

  # DELETE
  delete '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# delete - DELETE /api/homes/:uuid"
    content_type :json

    if params[:uuid] != $home[:uuid]
      error 404, "failed to find home with provided uuid and bearer token"
    end
# delete from mock database
    $home = {}
    { uuid: uuid }.to_json
  end
end

# This is what will run the server.
TerraTownsMockServer.run!