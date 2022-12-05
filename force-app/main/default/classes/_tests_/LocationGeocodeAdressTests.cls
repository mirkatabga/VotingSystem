@isTest
public with sharing class LocationGeocodeAdressTests {
    @isTest
    private static void testCoventToGeolocation() {
        // Arrange
        List<Location__c> locs = VotingDataFactory.createLocations();
        Test.setMock(HttpCalloutMock.class, new GeolocationCalloutMock());

        // Act
        Test.startTest();
        LocationGeocodeAddress.DoAddressGeocode(locs[0].Id);
        Test.stopTest();

        // Assert
        Location__c geoLocation = [
            SELECT Name, Address__c, Postion__Latitude__s
            FROM Location__c
            WHERE id = :locs[0].Id
            Limit 1
        ];
        System.assertEquals(geoLocation.Postion__Latitude__s, 49.2328817);
    }
}
