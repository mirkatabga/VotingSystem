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
        if (assignments.Voters != null) {
            repo.deleteAssignments(campaignId,  VOTER_RECORD_TYPE_NAME);
            repo.setAssignments(assignments.Voters, campaignId, VOTER_RECORD_TYPE_NAME);
        }

        if (assignments.Moderators != null) {
            repo.deleteAssignments(campaignId,  MODERATOR_RECORD_TYPE_NAME);
            repo.setAssignments(assignments.Moderators, campaignId, MODERATOR_RECORD_TYPE_NAME);
        }

        if (assignments.Configurators != null) {
            repo.deleteAssignments(campaignId,  CONFIGURATOR_RECORD_TYPE_NAME);
            repo.setAssignments(assignments.Configurators, campaignId, CONFIGURATOR_RECORD_TYPE_NAME);
        }

        if (assignments.Analysts != null) {
            repo.deleteAssignments(campaignId,  ANALYST_RECORD_TYPE_NAME);
            repo.setAssignments(assignments.Analysts, campaignId, ANALYST_RECORD_TYPE_NAME);
        }
    }
}
