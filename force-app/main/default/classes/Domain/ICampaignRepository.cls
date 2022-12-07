public interface ICampaignRepository {
    List<Id> getAssignedUserIds(Id campaignId, String userType);

    void deleteAssignments(Id campaignId, String userType);

    void setAssignments(List<Id> userIds, Id campaignId, String userType);
}
