public with sharing class CampaignController {

    @AuraEnabled
    public static List<Id> getAssignedUserIds(String campaignId, String userType) {
        List<User_Campaign__c> userCampaigns = [
            SELECT User__c
            FROM User_Campaign__c
            WHERE Campaign__c = :campaignId AND RecordType.Name = :userType
        ];

        List<Id> ids = new List<Id>();

        for (User_Campaign__c uc : userCampaigns) {
            ids.add(uc.User__c);
        }

        return ids;
    }
}
