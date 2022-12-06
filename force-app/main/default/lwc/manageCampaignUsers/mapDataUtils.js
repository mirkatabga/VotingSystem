class mapDataUtils {
   static mapUsersToDisplay(users) {
        return users.map(x => {
            return {
                value: x.id,
                label: x.name,
            };
        });
    }

    static mapUserRoles(roles) {
        return roles.map(x => {
            return {
                id: x.Id,
                role: x.Name.split(' ')[0],
            };
        });
    }

    static mapSelectedUses(users) {
        return users.map(x => {
            return x.id
        });
    }

    static mapUsers(users, isPotentialUserSet) {
        return users.map(x => {
            return {
                id: isPotentialUserSet ? x.AssigneeId : x.User_Id__r.Id,
                name: isPotentialUserSet ? x.Assignee.Name : x.User_Id__r.Name,
                role: isPotentialUserSet ? x.PermissionSet.Name : x.RecordType.Name
            };
        });
    }

    static mapSelectedCampaignUsers(allCampaignUsers, recordId, userRoles) {
        return allCampaignUsers.map(x => {
            return {
                Campaign_Id__c: recordId,
                Name: x.name,
                User_Id__c: x.id,
                RecordTypeId: userRoles.find(userRole => x.role.includes(userRole.role)).id
            };
        });
    }

 }

 export {mapDataUtils};