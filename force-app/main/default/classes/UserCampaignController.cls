public with sharing class UserCampaignController {
    @AuraEnabled
    public static List<SObject> getUserByCampaign(String campaignId) {
        return getCampaignUsers(campaignId);
    }

    @AuraEnabled(cacheable=true)
    public static List<SObject> getUserByCampaignCacheable(String campaignId) {
        return getCampaignUsers(campaignId);
    }

    @AuraEnabled(cacheable=true)
    public static List<SObject> getPotentialCampaignUsers() {
        return [
            SELECT Id, PermissionSetId, PermissionSet.Name, AssigneeId, Assignee.Name
            FROM PermissionSetAssignment
            WHERE PermissionSet.Name = :Constants.VOTER_PERMISSION_SET
                OR PermissionSet.Name = :Constants.CONFIGURATOR_PERMISSION_SET
                OR PermissionSet.Name = :Constants.MODERATOR_PERMISSION_SET
                OR PermissionSet.Name = :Constants.Analyst_PERMISSION_SET
            WITH SECURITY_ENFORCED
        ];
    }

    @AuraEnabled
    public static void saveCampaignLocations(List<Campaign_Location__c> campaignLocations, Id campaignId) {
        try {
            List<Campaign_Location__c> prevCampaignLocations = [
                SELECT Id
                FROM Campaign_Location__c
                WHERE Campaign_Id__c = :campaignId
            ];

            delete prevCampaignLocations;
            insert campaignLocations;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static void saveCampaignUsers(List<User_Campaign__c> campaignUsers, Id campaignId) {
        try {
            List<User_Campaign__c> prevCampaignUsers = [
                SELECT Id
                FROM User_Campaign__c
                WHERE Campaign_Id__c = :campaignId
            ];

            delete prevCampaignUsers;
            insert campaignUsers;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<SObject> getUserCampaignRecordType() {
        return [
            SELECT Id, Name
            FROM RecordType
            WHERE sObjectType = :Constants.USER_CAMPAIGN_TYPE
        ];
    }

    private static List<SObject> getCampaignUsers(String campaignId) {
        return [
            SELECT Name, User_Id__c, RecordType.Name, User_Id__r.Name, CreatedBy.Name
            FROM User_Campaign__c
            WHERE Campaign_Id__c = :campaignId
            WITH SECURITY_ENFORCED
        ];
    }
}
