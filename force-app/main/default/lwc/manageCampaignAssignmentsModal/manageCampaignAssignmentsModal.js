import { api } from 'lwc';
import LightningModal from 'lightning/modal';
import getCampaignAssignments from '@salesforce/apex/CampaignController.getCampaignAssignments';

export default class ManageCampaignAssignmentsModal extends LightningModal {
    @api recordId;

    connectedCallback(){
        console.log(this.recordId);
    }

    handleClose(){
        console.log('close handler');
        this.close('canceled');
    }

    handleSave(){
        console.log('success handler');
        this.close('success');
    }
}