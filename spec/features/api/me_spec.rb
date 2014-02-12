require "spec_helper"

describe "me" do
  before do
    @customer = create_customer "Peter", "Mustermann"
    create_user "another-user", "pw", :admin
    @user = create_user "peter", "pw", :customer

    login_with_api "peter", "pw"
    get "/api/v1/me"
  end

  let(:user_json) { json_response["user"] }

  it "responds with 200 OK" do
    expect(last_response.status).to eq 200
  end

  it "returns the currently logged in user" do
    expect(user_json["id"]).to eq @user.id
    expect(user_json["name"]).to eq "peter"
  end

  context "user is linked to customer" do
    before do
      link_user_to_customer @user.id, @customer.id
      get "/api/v1/me"
    end

    it "returns the connected customer" do
      expect(user_json["customer"]["id"]).to eq @customer.id
      expect(user_json["customer"]["forename"]).to eq "Peter"
    end
  end

  context "user is not linked to customer" do
    it "doesn't return a customer" do
      expect(user_json.keys).to_not include("customer", "")
    end
  end
end
