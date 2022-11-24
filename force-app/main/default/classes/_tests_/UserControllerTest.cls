@IsTest
private class UserControllerTest {
    @isTest
    static void TestIsUserConfigurator() {
        // Arrange
        User_Campaign__c testUserCampaign = UserCampaignDataFactory.creatCampaignWithUsers();

        // Act
        Boolean result = UserController.isUserConfigurator(testUserCampaign.User_Id__c);

        // Assert
        System.assertEquals(false, result);
    }
}
