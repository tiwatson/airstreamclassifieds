Feature: Products
  
  In order to get the price price on an Airstream
  As a savvy consumer
  I want to be able to see and compare past for sale listings

  Scenario: The root page shows a summary based on lengths
    Given a full compliment of active and sold trailers 
    When I visit the homepage
    Then I should see a summary with correct values
    And I should see links to each individual length page

  Scenario: The length page shows each trailer that has been for sale.
    Given a full compliment of active and sold trailers 
    When I visit the 25 footer length page
    Then I should see the 25 foot trailers

  Scenario: The length page is sortable by a few attributes
    Given a full compliment of active and sold trailers
    When I visit the 25 footer length sorted by price page
    Then I should see the cheapest trailer listed first 

  Scenario: Individual product page of active listing shows all important attributes
    Given an active trailer with full attributes
    When I visit that trailers product page
    Then I should see a message that it is still actively listed on airstreamclassifieds
    And I should see all archived attributes the are available