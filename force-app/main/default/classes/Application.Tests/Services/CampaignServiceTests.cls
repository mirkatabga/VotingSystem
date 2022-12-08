@IsTest
public with sharing class CampaignServiceTests {
    private static final String NOT_EXISTING_ID = '0057S00000143O5QAI';

    @TestSetup
    static void setup(){
        List<User> users = new List<User>();
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        users.add(new User(
            LastName = 'PETROV',
            FirstName='ALEX',
            Alias = 'apetr',
            Email = 'alex.petrov@asdf.com',
            Username = 'alex.petrov@asdf.com',
            ProfileId = profileId.id,
            TimeZoneSidKey = 'GMT',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LocaleSidKey = 'en_US'
        ));

        users.add(new User(
            LastName = 'GRIFFINOV',
            FirstName='PETER',
            Alias = 'pgrif',
            Email = 'peter.griffinov@asdf.com',
            Username = 'peter.griffinov@asdf.com',
            ProfileId = profileId.id,
            TimeZoneSidKey = 'GMT',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LocaleSidKey = 'en_US'
        ));

        insert users;

        List<Campaign__c> campaigns = new List<Campaign__c>();
        Campaign__c campaignOne = new Campaign__c();
        Campaign__c campaignTwo = new Campaign__c();

        campaignOne.Name = 'ut-campaign-1';
        campaigns.add(campaignOne);

        campaignTwo.Name = 'ut-campaign-2';
        campaigns.add(campaignTwo);

        insert campaigns;
    }

    @IsTest
    static void getAssignedUserIds_NotFound_ReturnsEmptyList(){
        Test.startTest();
        ICampaignService campaignService = new CampaignService();

        List<Id> userIds = campaignService.getAssignedUserIds(
            Id.valueOf(NOT_EXISTING_ID), 'non-existing');

        System.assert(userIds.size() == 0);
        Test.stopTest();      
    }
}
