@IsTest
public with sharing class UserCampaignDataFactory {
    public static User_Campaign__c creatCampaignWithUsers() {
        Campaign__c testCampaign = new Campaign__c(Name='Test Campaign');
        insert testCampaign;

        Profile testProfile = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User testUser = new User(Alias = 'standt',
            Email='testing@testorg.com', 
            EmailEncodingKey='UTF-8',
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Los_Angeles',
            UserName='testUserCampaign@testorg.com',
            ProfileId = testProfile.Id);
        insert testUser;

        User_Campaign__c userCampaign = new User_Campaign__c(Name='Test User Campaign',
            Campaign_Id__c=testCampaign.Id,
            User_Id__c=testUser.Id);
        insert userCampaign;

        return userCampaign;
    }
}
