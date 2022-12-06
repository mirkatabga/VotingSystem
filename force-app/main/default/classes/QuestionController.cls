public with sharing class QuestionController {
    @AuraEnabled
    public static List<SObject> getPotentialQuestions() {
        return [
            SELECT Id, Name
            FROM Question__c
            WITH SECURITY_ENFORCED
        ];
    }

    @AuraEnabled
    public static void saveQuestionAnswers(List<Question_Answer_Option__c> answers, Id questionId) {
        try {
            List<Question_Answer_Option__c> prevAnswers = [
                SELECT Id
                FROM Question_Answer_Option__c
                WHERE Question_Id__c = :questionId
            ];

            delete prevAnswers;
            insert answers;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static List<SObject> getQuestionBySurvey(String surveyId) {
        return [
            SELECT Name, Question_Id__r.Name, CreatedBy.Name
            FROM Survey_Question__c
            WHERE Survey_Id__c = :surveyId
            WITH SECURITY_ENFORCED
        ];
    }

    @AuraEnabled
    public static void saveSurveyQuestions(List<Survey_Question__c> surveyQuestions, Id surveyId) {
        try {
            List<Survey_Question__c> prevSurveyQuestion = [
                SELECT Id
                FROM Survey_Question__c
                WHERE Survey_Id__c = :surveyId
            ];

            delete prevSurveyQuestion;
            insert surveyQuestions;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}

