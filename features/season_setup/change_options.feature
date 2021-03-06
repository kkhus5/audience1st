Feature: change configuration options

  As an admin
  So that I can tailor Audience1st to my venue
  I want to see and edit the configuration options

Background: logged in as admin
  
  Given I am logged in as administrator
  And I visit the admin:settings page
  And I fill in all valid options

Scenario: successfully change options

  When I press "Update Settings"
  Then I should be on the admin:settings page
  And I should see "Update successful"

Scenario: venue cannot be blank

  When I fill in "Venue" with ""
  And I press "Update Settings"
  Then I should see "Venue can't be blank"

Scenario: change an encrypted option

  When I fill in "Stripe Secret" with "sekret"
  And I press "Update Settings"
  Then the setting "Stripe Secret" should be "sekret"

Scenario: invalid HTML email template because no placeholder

  When I upload the email template "invalid_template_no_placeholder.html"
  Then I should see "must contain exactly one occurrence of the placeholder"
