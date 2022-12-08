public with sharing class CampaignRepository implements ICampaignRepository {

    public List<Id> getAssignedUserIds(Id campaignId, String userType){
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

    public void deleteAssignments(Id campaignId, List<String> userTypes){
        delete [
            SELECT Id
            FROM User_Campaign__c
            WHERE Campaign__c = :campaignId AND RecordType.Name IN :userTypes
        ];
    }

    public void setAssignments(List<Id> userIds, Id campaignId, String userType){
        if(userIds.size() == 0){
            return;
        }

        Id recordTypeId = Schema.SObjectType.User_Campaign__c.getRecordTypeInfosByDeveloperName()
            .get(userType).getRecordTypeId();

        List<User_Campaign__c> userCampaigns = new List<User_Campaign__c>();

        for (String userId : userIds) {
            User_Campaign__c uc = new User_Campaign__c(
                User__c = userId,
                Campaign__c = campaignId,
                RecordTypeId = recordTypeId
            );

            userCampaigns.add(uc);
        }

        insert userCampaigns;
	} 
}
