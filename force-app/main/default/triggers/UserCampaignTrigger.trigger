trigger UserCampaignTrigger on User_Campaign__c (after insert, after update) {
    switch on Trigger.operationType {
        when AFTER_INSERT, AFTER_UPDATE{
            UserCampaignTriggerHandler.createRefreshRecordPlatformEvents(Trigger.new);
        }
    }
}