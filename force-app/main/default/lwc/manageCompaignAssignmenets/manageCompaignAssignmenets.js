import { LightningElement } from 'lwc';
import ManageCampaignAssignmentsModal from 'c/manageCampaignAssignmentsModal';

export default class ManageCampaignAssignments extends LightningElement {
    async handleClick() {
        await ManageCampaignAssignmentsModal.open({
            size: 'large'
        });
    }
}