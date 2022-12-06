
class mapDataUtils {
    static mapCampaignData(data, isInitialLoad, currentUser) {
        return data.map(x => {
            return {
                id: isInitialLoad ? x.Location_Id__r.Id : x.Id,
                name: isInitialLoad ? x.Location_Id__r.Name : x.Name,
                creatorName: isInitialLoad ? x.CreatedBy.Name : currentUser
            };
        });
    }

    static mapSurveyData(data, isInitialLoad, currentUser) {
        return data.map(x => {
            return {
                id: isInitialLoad ? x.Question_Id__r.Id : x.Id,
                name: isInitialLoad ? x.Question_Id__r.Name : x.Name,
                creatorName: isInitialLoad ? x.CreatedBy.Name : currentUser
            };
        });
    }

    static mapQuestionData(data, isInitialLoad, currentUser) {
        return data.map(x => {
            return {
                id: isInitialLoad ? x.Answer_Option_Id__r.Id : x.Id,
                name: isInitialLoad ? x.Answer_Option_Id__r.Name : x.Name,
                creatorName: isInitialLoad ? x.CreatedBy.Name : currentUser
            };
        });
    }

    static mapRecordsToDisplay(users) {
        return users.map(x => {
            return {
                value: x.Id,
                label: x.Name,
            };
        });
    }

    static mapSelectedRecords(users) {
        return users.map(x => {
            return x.id
        });
    }

    static mapSelectedCampaignLocations(selectedRecords, recordId) {
        return selectedRecords.map(x => {
            return {
                Campaign_Id__c: recordId,
                Location_Id__c: x,
            };
        });
    }

    static mapSelectedSurveyQuestions(selectedRecords, recordId) {
        return selectedRecords.map(x => {
            return {
                Survey_Id__c: recordId,
                Question_Id__c: x,
            };
        });
    }

    static mapSelectedQuestionAnswers(selectedRecords, recordId) {
        return selectedRecords.map(x => {
            return {
                Question_Id__c: recordId,
                Answer_Option_Id__c: x,
            };
        });
    }

}

export { mapDataUtils }