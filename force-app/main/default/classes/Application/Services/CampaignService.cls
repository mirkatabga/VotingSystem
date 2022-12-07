public class CampaignService implements ICampaignService {
    private final ICampaignRepository repo;

    public CampaignService() {
         repo = new CampaignRepository();
    }

    public List<Id> getAssignedUserIds(Id campaignId, String userType) {
        return repo.getAssignedUserIds(campaignId, userType);
    }

    public void setAssignedUserIds(Id campaignId, Assignments assignments){
        List<String> userTypes = assignments.GetUserTypesForAvailableData();
        repo.deleteAssignments(campaignId, userTypes);

        for (String userType : userTypes) {
            List<Id> userIds = assignments.GetUserIds(userType);
            repo.setAssignments(userIds, campaignId, userType);
        }       
    }
}
