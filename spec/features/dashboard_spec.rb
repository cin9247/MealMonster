require "spec_helper"

describe "dashboard" do
  it "displays an overview of the ordered offerings for today" do
    login_as_admin_web
    offering_1 = create_offering Date.today, "Frühstück"
    offering_2 = create_offering Date.today, "Hackfleisch"
    customer_1 = create_customer
    customer_2 = create_customer
    create_order customer_1.id, offering_1.id
    create_order customer_2.id, offering_1.id
    create_order customer_2.id, offering_2.id
    visit root_path

    expect(page).to have_content "2 mal Frühstück"
    expect(page).to have_content "1 mal Hackfleisch"
  end
end
