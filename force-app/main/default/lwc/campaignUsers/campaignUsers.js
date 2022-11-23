import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getUserByCampaign from '@salesforce/apex/UserCampaignController.getUserByCampaign';
import { subscribe, unsubscribe } from 'lightning/empApi';

export default class CampaignUsers extends NavigationMixin(LightningElement) {
    @api recordId;
    data;
    error;

    pageSize = 4;
    pageNumber = 1;
    totalRecords = 0;
    totalPages = 1;

    mappedData;
    recordsToDisplay;
    initialRecords;
    selectedRole = 'all';
    columns = [
        { label: 'Name', fieldName: 'name', sortable: true },
        { label: 'Role', fieldName: 'role', type: 'text', sortable: true },
        { label: 'Creator Name', fieldName: 'creatorName', type: 'text', sortable: true },
    ];

    subscription = {};
    CHANNEL_NAME = '/event/Refresh_Record_Event__e';

    connectedCallback() {
        this.fetchUserCampaign();
        subscribe(this.CHANNEL_NAME, -1, this.manageEvent).then(response => {
            this.subscription = response;
        });
    }

    manageEvent = event => {
        this.fetchUserCampaign();
    }

    fetchUserCampaign() {
        getUserByCampaign({ campaignId: this.recordId })
            .then(result => {
                this.data = result;
                this.mappedData = this.mapData();
                this.initialRecords = this.mappedData;
                this.totalRecords = this.mappedData.length;
                this.handlePagination();
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.data = undefined;
            });
    }

    disconnectedCallback() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.handlePagination();
    }

    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.handlePagination();
    }

    handleChangeRecords(event) {
        this.pageSize = event.target.value;
        this.handlePagination();
    }

    handlePagination() {
        this.recordsToDisplay = [];
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);

        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }

        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.recordsToDisplay.push(this.mappedData[i]);
        }
    }

    handleSearch(event) {
        this.selectedRole = 'all';
        const searchKey = event.target.value.toLowerCase();
        if (searchKey) {
            this.mappedData = this.initialRecords;
            if (this.mappedData) {
                let searchRecords = [];
                for (let record of this.mappedData) {
                    let strVal = String(record.name);
                    if (strVal) {
                        if (strVal.toLowerCase().includes(searchKey)) {
                            searchRecords.push(record);
                        }
                    }
                }

                this.mappedData = searchRecords;
                this.totalRecords = this.mappedData.length;
                this.handlePagination();
            }
        } else {
            this.mappedData = this.initialRecords;
            this.totalRecords = this.mappedData.length;
            this.handlePagination();
        }
    }

    handleRoleChange(event) {
        this.selectedRole = event.detail.value;
        this.template.querySelectorAll('lightning-input').forEach(element => {
            if (element.type === 'search') {
                element.value = null;
            }
        });
        if (this.selectedRole) {
            this.mappedData = this.initialRecords;
            if (this.mappedData && this.selectedRole !== 'all') {
                let searchRecords = [];
                for (let record of this.mappedData) {
                    let strVal = String(record.role);
                    if (strVal) {
                        if (strVal.toLowerCase().includes(this.selectedRole)) {
                            searchRecords.push(record);
                        }
                    }
                }
                this.mappedData = searchRecords;
            }

            this.totalRecords = this.mappedData.length;
            this.handlePagination();

        } else {
            this.mappedData = this.initialRecords;
            this.totalRecords = this.mappedData.length;
            this.handlePagination();
        }
    }

    mapData() {
        return this.data.map(x => {
            return {
                id: x.Id,
                name: x.User_Id__r.Name,
                role: x.RecordType.Name,
                creatorName: x.CreatedBy.Name
            };
        });
    }

    get disableFirst() {
        return this.pageNumber == 1;
    }
    get disableLast() {
        return this.pageNumber == this.totalPages;
    }

    get userRoleOptions() {
        return [
            { label: 'Voter Role', value: 'voter' },
            { label: 'Moderator Role', value: 'moderator' },
            { label: 'Configurator Role', value: 'configurator' },
            { label: 'Analyst Role', value: 'analyst' },
            { label: 'All Role', value: 'all' },
        ];
    }
}
