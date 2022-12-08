public with sharing class UserService implements IUserService {
    private final IUserRepository repo;

    public UserService() {
        repo = new UserRepository();
    }

    public List<User> getUsers(){
        return repo.getUsers();
    }
}
