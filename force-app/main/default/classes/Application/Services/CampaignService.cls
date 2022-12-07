public class CampaignService implements ICampaignService {
    private static final String VOTER_RECORD_TYPE_NAME = 'Voter';
    private static final String MODERATOR_RECORD_TYPE_NAME = 'Moderator';
    private static final String CONFIGURATOR_RECORD_TYPE_NAME = 'Configurator';
    private static final String ANALYST_RECORD_TYPE_NAME = 'Analyst';

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
