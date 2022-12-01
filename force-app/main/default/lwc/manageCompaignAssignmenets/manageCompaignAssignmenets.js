import { LightningElement, api } from 'lwc';
import ManageCampaignAssignmentsModal from 'c/manageCampaignAssignmentsModal';

export default class ManageCampaignAssignments extends LightningElement {
    @api recordId;

    async handleClick() {
        await ManageCampaignAssignmentsModal.open({
            size: 'large'
        });
    }
}