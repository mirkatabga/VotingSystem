public with sharing class UserController {
    @AuraEnabled
    public static List<User> getUsers() {
        return [
            SELECT Id, Name
            FROM User
        ];
    }
}
