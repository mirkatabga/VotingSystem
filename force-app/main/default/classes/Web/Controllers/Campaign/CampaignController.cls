public with sharing class CampaignController {
    @AuraEnabled(cacheable=false)
    public static List<Id> getAssignedUserIds(Id campaignId, String userType) {
        ICampaignService campaignService = new CampaignService();
        return campaignService.getAssignedUserIds(campaignId, userType);
    }

    @AuraEnabled(cacheable=false)
    public static void setAssignedUserIds(Id campaignId, String assignmentsJson) {
        AssignmentsViewModel assignmentsViewModel = (AssignmentsViewModel)json.deserialize(
            assignmentsJson, 
            AssignmentsViewModel.class);

        Assignments assignments = MapToAssignments(assignmentsViewModel);

        ICampaignService campaignService = new CampaignService();
        campaignService.setAssignedUserIds(campaignId, assignments);
    }

	private static Assignments MapToAssignments(AssignmentsViewModel assignmentsViewModel){
		Assignments assignments = new Assignments(
            assignmentsViewModel.Voters,
            assignmentsViewModel.Moderators,
            assignmentsViewModel.Configurators,
            assignmentsViewModel.Analysts
        );

        System.debug(json.serialize(assignments));
        return assignments;
	} 
}
