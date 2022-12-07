public with sharing class UserController {
    @AuraEnabled(cacheable=false)
    public static List<UserViewModel> getUsers() {
        IUserService userService = new UserService();
        List<User> users = userService.getUsers();

        return MapToUserViewModels(users);
    }

	private static List<UserViewModel> MapToUserViewModels(List<User> users){
        List<UserViewModel> userViewModels = new List<UserViewModel>();

        for (User user : users) {
            UserViewModel uvm = new UserViewModel();
            uvm.Id = user.Id;
            uvm.Name = user.Name;

            userViewModels.add(uvm);
        }

        return userViewModels;
	} 
}
