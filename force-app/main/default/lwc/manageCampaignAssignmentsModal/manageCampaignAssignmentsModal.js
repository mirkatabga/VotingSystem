import { api } from 'lwc';
import LightningModal from 'lightning/modal';
import getUsers from '@salesforce/apex/UserController.getUsers';
import getAssignedUserIds from '@salesforce/apex/CampaignController.getAssignedUserIds';
import setAssignedUserIds from '@salesforce/apex/CampaignController.setAssignedUserIds';

export default class ManageCampaignAssignmentsModal extends LightningModal {
    @api recordId;

    userOptions = [];
    voterValues = [];
    moderatorValues = [];
    configuratorValues = [];
    analystValues = [];

    connectedCallback(){
        this.fetchUsers()
            .then(users => {
                this.userOptions = this.mapUsersToOptions(users);

                this.fetchAssignments()
                    .then(results => {
                            this.voterValues.push(...results[0]);
                            this.moderatorValues.push(...results[1]);
                            this.configuratorValues.push(...results[2]);
                            this.analystValues.push(...results[3]);
                    });              
            });
    }

    handleClose(){
        this.close('canceled');
    }

    async handleSave(){
        let listBoxes = this.template.querySelectorAll('lightning-dual-listbox');
        const values = {};

        listBoxes.forEach(listBox => {
            values[listBox.dataset.type] = listBox.value;
        });

        await setAssignedUserIds(
            { 
                campaignId: this.recordId, 
                assignmentsJson: JSON.stringify(values) 
            });

        this.close('success');
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