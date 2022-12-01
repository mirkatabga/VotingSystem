@isTest
private class UserCampaignControllerTests {
    @isTest
    static void TestGetUserByCampaign() {
        // Arrange
        User_Campaign__c testUserCampaign = VotingDataFactory.creatCampaignWithUsers();

        // Act
        List<SObject> userCampaigns = UserCampaignController.getUserByCampaign(testUserCampaign.Campaign_Id__c);

        // Assert
        System.assertEquals(1, userCampaigns.size());
        System.assertEquals(testUserCampaign.Name, userCampaigns[0].get('Name'));
        System.assertEquals(testUserCampaign.User_Id__c, userCampaigns[0].get('User_Id__c'));
    }

    @isTest
    static void TestGetPotentialCampaignUsers() {
        // Act
        List<SObject> users = UserCampaignController.getPotentialCampaignUsers();

        // Assert
        System.assertNotEquals(0, users.size());
    }

    @isTest
    static void TestGetUserCampaignRecordType() {
        // Act
        List<SObject> roles = UserCampaignController.getUserCampaignRecordType();

        // Assert
        System.assertNotEquals(0, roles.size());
    }

    @isTest
    static void TestSaveCampaignUsers() {
        // Arrange
        User_Campaign__c insertedUserCampaign = VotingDataFactory.creatCampaignWithUsers();

        String newUserCampaignName = 'New User Campaign';
        User_Campaign__c newUserCampaign = new User_Campaign__c(
            Name = newUserCampaignName,
            Campaign_Id__c = insertedUserCampaign.Campaign_Id__c,
            User_Id__c = insertedUserCampaign.User_Id__c
        );

        List<User_Campaign__c> newUsers = new List<User_Campaign__c>{ newUserCampaign };

        // Act
        UserCampaignController.saveCampaignUsers(newUsers, insertedUserCampaign.Campaign_Id__c);

        // Assert
        List<User_Campaign__c> populatedUsers = [
            SELECT Id, Name
            FROM User_Campaign__c
        ];
        System.assertEquals(1, populatedUsers.size());
        System.assertEquals(newUserCampaignName, populatedUsers[0].Name);
    }

    @isTest
    static void TestSaveCampaignLocations() {
        // Arrange
        Campaign_Location__c insertedCampaignLocation = VotingDataFactory.createCampaingWithLocation();

        Campaign_Location__c newCampaignLocation = new Campaign_Location__c(
            Location_Id__c = insertedCampaignLocation.Location_Id__c,
            Campaign_Id__c = insertedCampaignLocation.Campaign_Id__c
        );

        List<Campaign_Location__c> newCampaignLocations = new List<Campaign_Location__c>{ newCampaignLocation };
        
        // Act
        UserCampaignController.saveCampaignLocations(newCampaignLocations, newCampaignLocation.Campaign_Id__c);

        // Assert
        List<Campaign_Location__c> populatedCampaignLocations = [
            SELECT Id, Name
            FROM Campaign_Location__c
        ];
        System.assertNotEquals(0, populatedCampaignLocations.size());
        System.assertNotEquals(insertedCampaignLocation.Name, populatedCampaignLocations[0].Name);
    }
}
