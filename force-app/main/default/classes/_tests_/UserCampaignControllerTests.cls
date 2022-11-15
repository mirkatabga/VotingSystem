@isTest
private class UserCampaignControllerTests {
    @isTest 
    static void TestDeleteAccountWithOneOpportunity() {
        // Arrange
        User_Campaign__c testUserCampaign = UserCampaignDataFactory.creatCampaignWithUsers();

        // Act
        List<SObject> userCampaigns = UserCampaignController.getUserByCampaign(testUserCampaign.Campaign_Id__c);

        // Assert
        System.assertEquals(1, userCampaigns.size());
        System.assertEquals(testUserCampaign.Name, userCampaigns[0].get('Name'));
        System.assertEquals(testUserCampaign.User_Id__c, userCampaigns[0].get('User_Id__c'));
    }        
}