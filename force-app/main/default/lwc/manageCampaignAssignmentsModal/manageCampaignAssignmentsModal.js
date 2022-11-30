import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class ManageCampaignAssignmentsModal extends LightningModal {
    connectedCallback(){
        
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