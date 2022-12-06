public with sharing class AnswerController {
    @AuraEnabled
    public static List<SObject> getAnswersByQuestion(String questionId) {
        return [
            SELECT Name, Answer_Option_Id__r.Name, CreatedBy.Name
            FROM Question_Answer_Option__c
            WHERE Question_Id__c = :questionId
            WITH SECURITY_ENFORCED
        ];
    }

    @AuraEnabled
    public static List<SObject> getPotentialAnswers() {
        return [
            SELECT Id, Name
            FROM Answer_Option__c
            WITH SECURITY_ENFORCED
        ];
    }
}
