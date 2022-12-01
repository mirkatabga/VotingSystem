import { api } from 'lwc';
import LightningModal from 'lightning/modal';
import getCampaignAssignments from '@salesforce/apex/CampaignController.getCampaignAssignments';

export default class ManageCampaignAssignmentsModal extends LightningModal {
    @api recordId;

    connectedCallback(){
        console.log('In connected call back function....');
        this.getAssignments();
    }

    handleClose(){
        console.log('close handler');
        this.close('canceled');
    }

    handleSave(){
        console.log('success handler');
        this.close('success');
    }

    getAssignments(){
            // getCampaignAssignments(this.recordId, 'Configurators')
            // .then((result) => console.log(result))
            // .catch((error) => console.log(error));

        // let assignments = {
        //     configurators: getCampaignAssignments(this.recordId, 'Configurators'),
        //     voters: getCampaignAssignments(this.recordId, 'Voters'),
        //     moderators: getCampaignAssignments(this.recordId, 'Moderators'),
        //     analysts: getCampaignAssignments(this.recordId, 'Analysts'),
        // }

        //return assignments;
    }
}