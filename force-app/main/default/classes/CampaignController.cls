public with sharing class CampaignController {

    @AuraEnabled
    public static List<Assignments> getCampaignAssignments(Id campaignId) {

        List<User_Campaign__c> assigned = [
            SELECT CreatedBy.Id
            FROM User_Campaign__c
            WHERE Campaign__c = :campaignId
        ];

        System.debug(assigned);

        return new List<Assignments>();
    }


    class Assignments {
        List<User> Available = new List<User>();
        List<User> Assigned = new List<User>();
    }
}
