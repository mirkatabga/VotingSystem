import { api } from 'lwc';
import LightningModal from 'lightning/modal';
import getUsers from '@salesforce/apex/UserController.getUsers';
import getAssignedUserIds from '@salesforce/apex/CampaignController.getAssignedUserIds';

export default class ManageCampaignAssignmentsModal extends LightningModal {
    @api recordId;

    userOptions = [];
    voterValues = [];
    moderatorValues = [];
    configuratorValues = [];
    analystValues = [];

    async connectedCallback(){
        const users = await this.fetchUsers();
        this.userOptions = this.mapUsersToOptions(users);
        const results = await this.fetchAssignments();

        this.voterValues.push(...results[0]);
        this.moderatorValues.push(...results[1]);
        this.configuratorValues.push(...results[2]);
        this.analystValues.push(...results[3]);
    }

    handleClose(){
        console.log('close handler');
        this.close('canceled');
    }

    handleSave(){
        console.log('success handler');
        this.close('success');
    }

    handleChange(event){
        console.log(event.target);
    }

    fetchUsers(){
        return getUsers();
    }

    fetchAssignments(){
        const promises = [
            getAssignedUserIds({ campaignId: this.recordId, userType: 'Voter' }),
            getAssignedUserIds({ campaignId: this.recordId, userType: 'Moderator' }),
            getAssignedUserIds({ campaignId: this.recordId, userType: 'Configurator' }),
            getAssignedUserIds({ campaignId: this.recordId, userType: 'Analyst' })
        ];

        return Promise.all(promises)
    }

    mapUsersToOptions(users){
        const options = users.map((user) => {
            return {
                label: user.Name,
                value: user.Id
            };
        });

        return options;
    }
}