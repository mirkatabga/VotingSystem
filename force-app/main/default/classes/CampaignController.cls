public with sharing class CampaignController {

    @AuraEnabled(cacheable=false)
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

    @AuraEnabled(cacheable=false)
    public static void setAssignedUserIds(String campaignId, String assignmentsJson) {
        Assignments assignments = (Assignments)json.deserialize(assignmentsJson, Assignments.class);

        if (assignments.Voters != null && assignments.Voters.size() > 0) {
            setAssignments(assignments.Voters, 'Voter', campaignId);
        }

        if (assignments.Moderators != null && assignments.Moderators.size() > 0) {
            setAssignments(assignments.Moderators, 'Moderator', campaignId);
        }

        if (assignments.Configurators != null && assignments.Configurators.size() > 0) {
            setAssignments(assignments.Configurators, 'Configurator', campaignId);
        }

        if (assignments.Analysts != null && assignments.Analysts.size() > 0) {
            setAssignments(assignments.Analysts, 'Analyst', campaignId);
        }

        System.debug(assignments);
    }

    private static void setAssignments(List<Id> userIds, String userType, String campaignId){
        delete [
            SELECT Id
            FROM User_Campaign__c
            WHERE User__c IN :userIds AND RecordType.Name = :userType
        ];

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

    public class Assignments{

        @auraEnabled
        public List<Id> Voters;

        @auraEnabled
        public List<Id> Moderators;

        @auraEnabled
        public List<Id> Configurators;

        @auraEnabled
        public List<Id> Analysts;
    }
}
