public with sharing class UserController {
    @AuraEnabled(cacheable=false)
    public static List<User> getUsers() {
        return [
            SELECT Id, Name
            FROM User
        ];
    }
}
