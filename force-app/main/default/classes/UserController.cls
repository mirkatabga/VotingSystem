public with sharing class UserController {
    @AuraEnabled(cacheable=true)
    public static Boolean isUserConfigurator(String userId) {
        List<SObject> userPermissionSets = [
            SELECT Id, PermissionSet.Name
            FROM PermissionSetAssignment
            WHERE Assignee.Id = :userId AND PermissionSet.Name = :Constants.CONFIGURATOR_PERMISSION_SET
            WITH SECURITY_ENFORCED
        ];

        return userPermissionSets.size() > 0;
    }
}