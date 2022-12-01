public with sharing class CampaignController {

    @AuraEnabled
    public static Assignments getCampaignAssignments(Id campaignId, String userType) {

        Assignments assignments = new Assignments();
        List<User> all = getAllUsers();

        assignments.Assigned = selectAlreadyAssigned(all, campaignId, userType);
        assignments.Available = selectAvailable(all, assignments.Assigned);
        
        return assignments;
    }


    public class Assignments {
        List<User> Available = new List<User>();
        List<User> Assigned = new List<User>();
    }

	private static List<User> getAllUsers(){
		return [
            SELECT Id, Name
            FROM User
        ];
	} 

	private static List<User> selectAlreadyAssigned(List<User> all, Id campaignId, String userType){
		List<User> assigned = new List<User>();

        List<User_Campaign__c> userCampaigns = [
            SELECT Campaign__c, User__c
            FROM User_Campaign__c
            WHERE Campaign__c = :campaignId AND RecordType.Name = :userType
        ];

        for (User_Campaign__c uc : userCampaigns) {
            
            for (User user : all) {
                
                if(uc.User__c == user.Id){
                    assigned.add(user);
                }
            }
        }

        return assigned;
	} 

	private static List<User> selectAvailable(List<User> all, List<User> assigned){
		List<User> available = new List<User>();
        Boolean include = true;
        
        for (User user : all) {
            for (User assignedUser : assigned) {

                if(user.Id == assignedUser.Id){
                    include = false;
                    break;
                }
            }

            if(include){
                available.add(user);
                continue;
            }

            include = true;
        }

        return available;
	} 
}
