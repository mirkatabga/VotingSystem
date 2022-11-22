@isTest
private class UserCampaignTriggerHandlerTest {
    @isTest 
    static void TestGetUserCampaignRecordType() {
        // Act
        User_Campaign__c testUserCampaign = UserCampaignDataFactory.creatCampaignWithUsers();

        // Assert
        System.assertEquals(1, UserCampaignDataFactory.eventList.size());
    }
}
