@isTest
public with sharing class LocationControllerTests {
    @isTest
    static void TestGetPotentialLocations() {
        // Arrange
        List<Location__c> createdLocations = VotingDataFactory.createLocations();

        // Act
        List<SObject> result = LocationController.getPotentialCampaignLocations();

        // Assert
        System.assertNotEquals(0, result.size());
    }

    @isTest
    static void TestGetLocationByCampaign() {
        // Arrange
        Campaign_Location__c insertedCampaignLocation = VotingDataFactory.createCampaingWithLocation();

        // Act
        List<SObject> result = LocationController.getLocationByCampaign(insertedCampaignLocation.Campaign_Id__c);

        // Assert
        System.assertEquals(1, result.size());
    }
}
