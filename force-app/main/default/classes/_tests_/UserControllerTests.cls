@IsTest
private class UserControllerTests {
    @isTest
    static void TestIsUserConfigurator() {
        // Arrange
        User_Campaign__c testUserCampaign = VotingDataFactory.creatCampaignWithUsers();

        // Act
        Boolean result = UserController.isUserConfigurator(testUserCampaign.User_Id__c);

        // Assert
        System.assertEquals(false, result);
    }
}
