public with sharing class UserCampaignController {
    @AuraEnabled
    public static List<SObject> getUserByCampaign(String campaignId) {
        return [
            SELECT Name, User_Id__c, RecordType.Name, User_Id__r.Name, CreatedBy.Name
            FROM User_Campaign__c
            WHERE Campaign_Id__c = :campaignId
            WITH SECURITY_ENFORCED
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<SObject> getPotentialCampaignUsers() {
        return [
            SELECT Id, PermissionSetId, PermissionSet.Name, AssigneeId, Assignee.Name
            FROM PermissionSetAssignment
            WHERE
                PermissionSet.Name = 'Voter_User'
                OR PermissionSet.Name = 'Configurator_User'
                OR PermissionSet.Name = 'Moderator_User'
                OR PermissionSet.Name = 'Analyst_User'
            WITH SECURITY_ENFORCED
        ];
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
            WHERE sObjectType = 'User_Campaign__c'
        ];
    }
}
