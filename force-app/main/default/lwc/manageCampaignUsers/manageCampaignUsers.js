// LWC
import { LightningElement, wire, api } from 'lwc';
import Id from '@salesforce/user/Id';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

// Apex Controllers
import getUserByCampaignCacheable from '@salesforce/apex/UserCampaignController.getUserByCampaignCacheable';
import getPotentialCampaignUsers from '@salesforce/apex/UserCampaignController.getPotentialCampaignUsers';
import saveCampaignUsers from '@salesforce/apex/UserCampaignController.saveCampaignUsers';
import getUserCampaignRecordType from '@salesforce/apex/UserCampaignController.getUserCampaignRecordType';
import isUserConfigurator from '@salesforce/apex/UserController.isUserConfigurator';

// Utils
import { mapDataUtils } from './mapDataUtils';

export default class ManageCampaignUsers extends NavigationMixin(LightningElement) {
    @api recordId;

    selectedRole = 'Voter';
    allPotentialUsers;
    allCampaignUsers;
    userRoles;
    isConfigurator;
    usersData;
    isComponentLoaded = false;

    subscription = {};

    @wire(getUserByCampaignCacheable, { campaignId: '$recordId' })
    wiredUserByCampaign(value) {
        this.usersData = value;
        const { data, error } = value;
        if (data) {
            this.allCampaignUsers = mapDataUtils.mapUsers(data, false);
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    }

    @wire(getUserCampaignRecordType)
    wiredUserRoles({ error, data }) {
        if (data) {
            this.userRoles = mapDataUtils.mapUserRoles(data);
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    }

    @wire(isUserConfigurator, { userId: Id })
    wireUserPermissionSet({ error, data }) {
        if (data) {
            this.isConfigurator = data;
            this.isComponentLoaded = true;
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getPotentialCampaignUsers)
    wiredPotentialCampaignUsers({ error, data }) {
        if (data) {
            this.allPotentialUsers = mapDataUtils.mapUsers(data, true);
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    }
   
    handleRoleChange(event) {
        this.selectedRole = event.detail.value;
    }

    handleSave() {
        let campaignUsers = mapDataUtils.mapSelectedCampaignUsers(this.allCampaignUsers, this.recordId, this.userRoles);
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
                    refreshApex(this.usersData).then(() => {
                        this.allCampaignUsers = mapDataUtils.mapUsers(this.usersData.data, false);
                    })
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
            result = mapDataUtils.mapUsersToDisplay(result);
        }
        return result;
    }

    get selectedUsers() {
        let result = [];
        if (this.allPotentialUsers && this.allCampaignUsers) {
            result.push(...this.allCampaignUsers);
            result = result.filter(x => x.role.includes(this.selectedRole));
            result = mapDataUtils.mapSelectedUses(result);
        }
        return result;
    }

    get userRoleOptions() {
        return [
            { label: 'Voters', value: 'Voter' },
            { label: 'Moderators', value: 'Moderator' },
            { label: 'Configurators', value: 'Configurator' },
            { label: 'Analysts', value: 'Analyst' },
        ];
    }
}
