require "rails_helper"

RSpec.describe "Admin: Editing Volunteers", type: :system do
  let(:admin) { create(:user, :casa_admin) }
  let(:volunteer) { create(:user, :volunteer) }

  it "saves the user as inactive, but only if the admin confirms" do
    sign_in admin
    visit edit_volunteer_path(volunteer)

    dismiss_confirm do
      click_on "Deactivate volunteer"
    end
    expect(page).not_to have_text('Volunteer was deactivated on')

    accept_confirm do
      click_on "Deactivate volunteer"
    end
    expect(page).to have_text('Volunteer was deactivated on')

    expect {
      volunteer.reload
    }.to change { volunteer.role }.from("volunteer").to("inactive")
  end

  it "allows an admin to reactivate a volunteer" do
    volunteer = create(:user, :volunteer, role: "inactive")
    sign_in admin
    visit edit_volunteer_path(volunteer)

    click_on "Activate volunteer"

    expect(page).not_to have_text('Volunteer was deactivated on')

    expect {
      volunteer.reload
    }.to change { volunteer.role }.from("inactive").to("volunteer")
  end
end
