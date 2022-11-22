public with sharing class UserCampaignTriggerHandler {
    @TestVisible private static List<Refresh_Record_Event__e> eventList = new List<Refresh_Record_Event__e>();

    public static void createRefreshRecordPlatformEvents(List<User_Campaign__c> newUserCampaigns){
        
        Refresh_Record_Event__e refreshEventObj = new Refresh_Record_Event__e();
        
        if(newUserCampaigns == null || newUserCampaigns.isEmpty())
            return;
                     
        for (User_Campaign__c user : newUserCampaigns) {
            refreshEventObj = new Refresh_Record_Event__e();
            refreshEventObj.Record_Id__c = user.Id;
            refreshEventObj.User_Id__c = UserInfo.getUserId();
            
            eventList.add(refreshEventObj);
        }
        
        try{
            if(eventList <> null && !eventList.isEmpty())
                EventBus.publish(eventList);
        }catch(Exception e){
            System.debug('Exception during publishing of refresh platform events-->'+e.getMessage());
        }
    }
}
