class UsersSerializer
  include JSONAPI::Serializer

  set_id :_id
  set_type :users
  attributes :email, :api_key
end
