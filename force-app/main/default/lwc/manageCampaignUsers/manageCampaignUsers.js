import { LightningElement, wire, api } from 'lwc';
import getUserByCampaign from '@salesforce/apex/UserCampaignController.getUserByCampaign';
import getPotentialCampaignUsers from '@salesforce/apex/UserCampaignController.getPotentialCampaignUsers';
import saveCampaignUsers from '@salesforce/apex/UserCampaignController.saveCampaignUsers';
import getUserCampaignRecordType from '@salesforce/apex/UserCampaignController.getUserCampaignRecordType';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';
import { subscribe, unsubscribe } from 'lightning/empApi';

export default class ManageCampaignUsers extends NavigationMixin(LightningElement) {
    @api recordId;

    selectedRole = 'Voter';
    allPotentialUsers;
    allCampaignUsers;
    userRoles;

    subscription = {};
    CHANNEL_NAME = '/event/Refresh_Record_Event__e';

    connectedCallback() {
        setTimeout(() => {
            this.fetchUserCampaign();
            subscribe(this.CHANNEL_NAME, -1, this.manageEvent).then(response => {
                this.subscription = response;
            });
        }, 5);
    }

    manageEvent = event => {
        this.fetchUserCampaign();
    }

    disconnectedCallback() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    fetchUserCampaign() {
        getUserByCampaign({ campaignId: this.recordId })
            .then(result => {
                this.allCampaignUsers = this.mapUsers(result, false);
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.data = undefined;
            });
    }

    @wire(getUserCampaignRecordType)
    wiredUserRoles({ error, data }) {
        if (data) {
            this.userRoles = this.mapUserRoles(data);
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    }

    @wire(getPotentialCampaignUsers)
    wiredPotentialCampaignUsers({ error, data }) {
        if (data) {
            this.allPotentialUsers = this.mapUsers(data, true);
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    }

    mapUsersToDisplay(users) {
        return users.map(x => {
            return {
                value: x.id,
                label: x.name,
            };
        });
    }

    mapUserRoles(roles) {
        return roles.map(x => {
            return {
                id: x.Id,
                role: x.Name.split(' ')[0],
            };
        });
    }

    mapSelectedUses(users) {
        return users.map(x => {
            return x.id
        });
    }

    mapSelectedCampaignUsers() {
        return this.allCampaignUsers.map(x => {
            return {
                Campaign_Id__c: this.recordId,
                Name: x.name,
                User_Id__c: x.id,
                RecordTypeId: this.userRoles.find(userRole => x.role.includes(userRole.role)).id
            };
        });
    }

    mapUsers(users, isPotentialUserSet) {
        return users.map(x => {
            return {
                id: isPotentialUserSet ? x.AssigneeId : x.User_Id__r.Id,
                name: isPotentialUserSet ? x.Assignee.Name : x.User_Id__r.Name,
                role: isPotentialUserSet ? x.PermissionSet.Name : x.RecordType.Name
            };
        });
    }

    handleRoleChange(event) {
        this.selectedRole = event.detail.value;
        this.userOptions;
        this.selectedUsers;
    }

    handleSave(event) {
        let campaignUsers = this.mapSelectedCampaignUsers();
        saveCampaignUsers({ campaignUsers: campaignUsers, campaignId: this.recordId })
            .then(result => {
                this.message = result;
                this.error = undefined;
                if (this.message !== undefined) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Campaign Users Updated',
                            variant: 'success',
                        }),
                    );
                    this.dispatchEvent(new CloseActionScreenEvent());
                }
            })
            .catch(error => {
                this.message = undefined;
                this.error = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: this.error,
                        variant: 'fail',
                    }),
                );
            });
    }

    handleUsersChange(event) {
        let selectedUsers = event.detail.value;
        this.allCampaignUsers = this.allCampaignUsers.filter(x => !x.role.includes(this.selectedRole));
        let movedUsers = this.allPotentialUsers.filter(
            val => selectedUsers.find(x => x === val.id && val.role.includes(this.selectedRole))
        );
        this.allCampaignUsers.push(...movedUsers);
        this.userOptions;
        this.selectedUsers;
    }

    get userOptions() {
        let result = [];
        if (this.allPotentialUsers && this.allCampaignUsers) {
            result.push(...this.allCampaignUsers);
            let addedUsersForSelectedRole = this.allCampaignUsers.filter(x => x.role.includes(this.selectedRole));
            let notAddedUsers = this.allPotentialUsers.filter(
                val => !addedUsersForSelectedRole.find(x => x.id === val.id)
            );
            result.push(...notAddedUsers);
            result = result.filter(x => x.role.includes(this.selectedRole));
            result = this.mapUsersToDisplay(result);
        }
        return result;
    }

    get selectedUsers() {
        let result = [];
        if (this.allPotentialUsers && this.allCampaignUsers) {
            result.push(...this.allCampaignUsers);
            result = result.filter(x => x.role.includes(this.selectedRole));
            result = this.mapSelectedUses(result);
        }
        return result;
    }

    get comboBoxOptions() {
        return [
            { label: 'Voters', value: 'Voter' },
            { label: 'Moderators', value: 'Moderator' },
            { label: 'Configurators', value: 'Configurator' },
            { label: 'Analysts', value: 'Analyst' },
        ];
    }
}