public with sharing class UserCampaignController {
    @AuraEnabled(cacheable=true)
    public static List<SObject> getUserByCampaign(Id campaignId) {
        return [
            SELECT Name, User_Id__c, RecordType.Name, User_Id__r.Name, CreatedBy.Name
            FROM User_Campaign__c
            WHERE Campaign_Id__c = :campaignId
            WITH SECURITY_ENFORCED
       ];
    }
}