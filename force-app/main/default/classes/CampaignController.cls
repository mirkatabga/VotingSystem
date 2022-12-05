public with sharing class CampaignController {

    @AuraEnabled(cacheable=false)
    public static List<Id> getAssignedUserIds(Id campaignId, String userType) {
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
    public static void setAssignedUserIds(Id campaignId, String assignmentsJson) {
        Assignments assignments = (Assignments)json.deserialize(assignmentsJson, Assignments.class);

        if (assignments.Voters != null) {
            String userType = 'Voter';
            deleteAssignments(campaignId,  userType);
            setAssignments(assignments.Voters, campaignId, userType);
        }

        if (assignments.Moderators != null) {
            String userType = 'Moderator';
            deleteAssignments(campaignId,  userType);
            setAssignments(assignments.Moderators, campaignId, userType);
        }

        if (assignments.Configurators != null) {
            String userType = 'Configurator';
            deleteAssignments(campaignId,  userType);
            setAssignments(assignments.Configurators, campaignId, userType);
        }

        if (assignments.Analysts != null) {
            String userType = 'Analyst';
            deleteAssignments(campaignId,  userType);
            setAssignments(assignments.Analysts, campaignId, userType);
        }

        System.debug(assignments);
    }

    private static void deleteAssignments(Id campaignId, String userType){
        delete [
            SELECT Id
            FROM User_Campaign__c
            WHERE Campaign__c = :campaignId AND RecordType.Name = :userType
        ];
    }

    private static void setAssignments(List<Id> userIds, Id campaignId, String userType){
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
