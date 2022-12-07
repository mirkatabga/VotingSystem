public with sharing class UserRepository implements IUserRepository {
    public List<User> getUsers(){
        return [
            SELECT Id, Name
            FROM User
        ];
    }
}
