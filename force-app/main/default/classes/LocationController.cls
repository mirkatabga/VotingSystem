public with sharing class LocationController {
    @AuraEnabled
    public static List<SObject> getPotentialCampaignLocations() {
        return [
            SELECT Id, Name
            FROM Location__c
            WITH SECURITY_ENFORCED
        ];
    }

    @AuraEnabled
    public static List<SObject> getLocationByCampaign(String campaignId) {
        return [
            SELECT Name, Location_Id__r.Name, CreatedBy.Name
            FROM Campaign_Location__c
            WHERE Campaign_Id__c = :campaignId
            WITH SECURITY_ENFORCED
        ];
    }
}
