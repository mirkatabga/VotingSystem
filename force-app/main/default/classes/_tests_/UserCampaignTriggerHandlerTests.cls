@isTest
private class UserCampaignTriggerHandlerTests {
    @isTest
    static void TestGetUserCampaignRecordType() {
        // Act
        User_Campaign__c testUserCampaign = VotingDataFactory.creatCampaignWithUsers();

        // Assert
        System.assertEquals(1, UserCampaignTriggerHandler.eventList.size());
    }
}
