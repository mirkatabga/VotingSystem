public interface ICampaignService {
    List<Id> getAssignedUserIds(Id campaignId, String userType);

    void setAssignedUserIds(Id campaignId, Assignments assignments);
}
