import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getLocationByCampaign from '@salesforce/apex/LocationController.getLocationByCampaign';
import saveCampaignLocations from '@salesforce/apex/UserCampaignController.saveCampaignLocations';
import getQuestionBySurvey from '@salesforce/apex/QuestionController.getQuestionBySurvey';
import saveSurveyQuestions from '@salesforce/apex/QuestionController.saveSurveyQuestions';
import getAnswersByQuestion from '@salesforce/apex/AnswerController.getAnswersByQuestion';
import saveQuestionAnswers from '@salesforce/apex/QuestionController.saveQuestionAnswers';
import getPotentialQuestions from '@salesforce/apex/QuestionController.getPotentialQuestions';
import getPotentialCampaignLocations from '@salesforce/apex/LocationController.getPotentialCampaignLocations';
import getPotentialAnswers from '@salesforce/apex/AnswerController.getPotentialAnswers';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Id from '@salesforce/user/Id';
import UserNameFIELD from '@salesforce/schema/User.Name';
const CAMPAIGN = 'Campaign';
const SURVEY = 'Survey';
const ANSWER = 'Answer';

export default class GenericTable extends NavigationMixin(LightningElement) {
    @api recordId;
    userId = Id;
    mangeClicked = false;

    title;
    data;
    error;
    currentUser;

    pageSize = 4;
    pageNumber = 1;
    totalRecords = 0;
    totalPages = 1;

    mappedData;
    recordsToDisplay;
    initialRecords;

    potentialRecords;

    columns = [
        { label: 'Name', fieldName: 'name', sortable: true },
        { label: 'Creator Name', fieldName: 'creatorName', type: 'text', sortable: true },
        { type: 'action', typeAttributes: { rowActions: [{ label: 'Show details', name: 'show_details' }] } }
    ];

    @wire(getRecord, { recordId: '$recordId', layoutTypes: ['Full'], modes: ['View'] })
    wiredObject({ error, data }) {
        if (data) {
            this.fetchData(data.apiName);
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getRecord, { recordId: Id, fields: [UserNameFIELD] })
    wiredUser({ error, data }) {
        if (data) {
            this.currentUser = data.fields.name;
        } else if (error) {
            this.error = error;
        }
    }

    fetchData(apiName){
        if (apiName.includes(CAMPAIGN)) {
            this.title = 'Campaign Locations';
            this.fetchCampaignLocations();
            this.fetchPotentialLocations();
        } else if (apiName.includes(SURVEY)) {
            this.title = 'Survey Questions';
            this.fetchSurveyQuestions();
            this.fetchPotentialQuestions();
        } else if (apiName.includes(ANSWER)) {
            this.title = 'Question Answers';
            this.fetchQuestionAnswers();
            this.fetchPotentialAnswers();
        }
    }

    fetchCampaignLocations() {
        getLocationByCampaign({ campaignId: this.recordId })
            .then(result => {
                this.handleGetResultSuccess(result);
            })
            .catch(error => {
                this.handleGetResultError(error);
            });
    }

    fetchPotentialLocations() {
        getPotentialCampaignLocations()
            .then(result => {
                this.potentialRecords = result;
            })
            .catch(error => {
                this.error = error;
            });
    }

    fetchSurveyQuestions() {
        getQuestionBySurvey({ surveyId: this.recordId })
            .then(result => {
                this.handleGetResultSuccess(result);
            })
            .catch(error => {
                this.handleGetResultError(error);
            });
    }

    fetchPotentialQuestions() {
        getPotentialQuestions()
            .then(result => {
                this.potentialRecords = result;
            })
            .catch(error => {
                this.error = error;
            });
    }

    fetchQuestionAnswers() {
        getAnswersByQuestion({ questionId: this.recordId })
            .then(result => {
                this.handleGetResultSuccess(result);
            })
            .catch(error => {
                this.handleGetResultError(error);
            });
    }

    fetchPotentialAnswers() {
        getPotentialAnswers()
            .then(result => {
                this.potentialRecords = result;
            })
            .catch(error => {
                this.error = error;
            });
    }

    handleGetResultSuccess(result) {
        this.data = result;
        this.mapAllDataTypes(result, true);
        this.initialRecords = this.mappedData;
        this.totalRecords = this.mappedData.length;
        this.handlePagination();
        this.error = undefined;
    }

    handleGetResultError(error) {
        this.data = undefined;
        this.error = error;
    }

    handleRecordsChange(event) {
        const selectedRecords = event.detail.value;
        let movedRecords = this.potentialRecords.filter(
            val => selectedRecords.find(x => x === val.Id)
        );

        this.mapAllDataTypes(movedRecords, false);
    }

    openManageComponent() {
        this.mangeClicked = true;
    }

    closeManageComponent() {
        this.mangeClicked = false;
    }

    handleShowDetails(event) {
        const row = event.detail.row;

        const objId = row.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: objId,
                actionName: 'view'
            }
        });
    }

    handleSave() {
        if (this.title.includes(CAMPAIGN)) {
            const records = this.mapSelectedCampaignLocations();
            saveCampaignLocations({ campaignLocations: records, campaignId: this.recordId })
                .then(result => {
                    this.handleSaveSuccess(result);
                })
                .catch(error => {
                    this.handleSaveError(error);
                });
        } else if (this.title.includes(SURVEY)) {
            const records = this.mapSelectedSurveyQuestions();
            saveSurveyQuestions({ surveyQuestions: records, surveyId: this.recordId })
                .then(result => {
                    this.handleSaveSuccess(result);
                })
                .catch(error => {
                    this.handleSaveError(error);
                });
        } else if (this.title.includes(ANSWER)) {
            const records = this.mapSelectedQuestionAnswers();
            saveQuestionAnswers({ answers: records, questionId: this.recordId })
                .then(result => {
                    this.handleSaveSuccess(result);
                })
                .catch(error => {
                    this.handleSaveError(error);
                });
        }
    }

    handleSaveSuccess(result) {
        this.message = result;
        this.error = undefined;
        if (this.message !== undefined) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Updated',
                    variant: 'success',
                }),
            );
            this.mangeClicked = false;
            window.location.reload()
        }
    }

    handleSaveError(error) {
        this.message = undefined;
        this.error = error;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: this.error,
                variant: 'fail',
            }),
        );
    }

    mapCampaignData(data, isInitialLoad) {
        return data.map(x => {
            return {
                id: isInitialLoad ? x.Location_Id__r.Id : x.Id,
                name: isInitialLoad ? x.Location_Id__r.Name : x.Name,
                creatorName: isInitialLoad ? x.CreatedBy.Name : this.currentUser
            };
        });
    }

    mapSurveyData(data, isInitialLoad) {
        return data.map(x => {
            return {
                id: isInitialLoad ? x.Question_Id__r.Id : x.Id,
                name: isInitialLoad ? x.Question_Id__r.Name : x.Name,
                creatorName: isInitialLoad ? x.CreatedBy.Name : this.currentUser
            };
        });
    }

    mapQuestionData(data, isInitialLoad) {
        return data.map(x => {
            return {
                id: isInitialLoad ? x.Answer_Option_Id__r.Id : x.Id,
                name: isInitialLoad ? x.Answer_Option_Id__r.Name : x.Name,
                creatorName: isInitialLoad ? x.CreatedBy.Name : this.currentUser
            };
        });
    }

    mapAllDataTypes(data, isInitial){
        if (this.title.includes(CAMPAIGN)) {
            this.mappedData = this.mapCampaignData(data, isInitial);
        } else if (this.title.includes(SURVEY)) {
            this.mappedData = this.mapSurveyData(data, isInitial);
        } else if (this.title.includes(ANSWER)) {
            this.mappedData = this.mapQuestionData(data, isInitial);
        }
    }

    mapRecordsToDisplay(users) {
        return users.map(x => {
            return {
                value: x.Id,
                label: x.Name,
            };
        });
    }

    mapSelectedRecords(users) {
        return users.map(x => {
            return x.id
        });
    }

    mapSelectedCampaignLocations() {
        return this.selected.map(x => {
            return {
                Campaign_Id__c: this.recordId,
                Location_Id__c: x,
            };
        });
    }

    mapSelectedSurveyQuestions() {
        return this.selected.map(x => {
            return {
                Survey_Id__c: this.recordId,
                Question_Id__c: x,
            };
        });
    }

    mapSelectedQuestionAnswers() {
        return this.selected.map(x => {
            return {
                Question_Id__c: this.recordId,
                Answer_Option_Id__c: x,
            };
        });
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

    handleChangeRecords(event) {
        this.pageSize = event.target.value;
        this.handlePagination();
    }

    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.handlePagination();
    }

    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.handlePagination();
    }

    get options() {
        let result = [];
        if (this.potentialRecords) {
            result = this.mapRecordsToDisplay(this.potentialRecords);
        }
        return result;
    }

    get selected() {
        let result = [];
        if (this.mappedData) {
            result = this.mapSelectedRecords(this.mappedData);
        }
        return result;
    }

    get disableFirst() {
        return this.pageNumber === 1;
    }
    get disableLast() {
        return this.pageNumber === this.totalPages;
    }
}