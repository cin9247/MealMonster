require "spec_helper"

describe "authorization" do
  before do
    create_admin "admin", "admin"
  end

  context "given no username and no password given" do
    before do
      get "api/v1/tours", date: "2014-10-02"
    end

    it "returns 401 Not Authorized" do
      expect(last_response.status).to eq 401
    end
  end

  context "given only username given" do
    before do
      basic_authorize "admin", ""
      get "api/v1/tours", date: "2014-10-02"
    end

    it "returns 401 Not Authorized" do
      expect(last_response.status).to eq 401
    end
  end

  context "given username with incorrect password" do
    before do
      basic_authorize "admin", "bla"
      get "api/v1/tours", date: "2014-10-02"
    end

    it "returns 401 Not Authorized" do
      expect(last_response.status).to eq 401
    end
  end

  context "given username with correct password" do
    before do
      basic_authorize "admin", "admin"
      get "api/v1/tours", date: "2014-10-02"
    end

    it "returns 200 OK" do
      expect(last_response.status).to eq 200
    end
  end
end
