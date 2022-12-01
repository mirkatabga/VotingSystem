@isTest
public with sharing class QuestionControllerTests {
    @isTest
    static void TestGetPotentialQuestions() {
        // Arrange
        List<Question__c> createdQuestions = VotingDataFactory.createQuestions();

        // Act
        List<SObject> result = QuestionController.getPotentialQuestions();

        // Assert
        System.assertNotEquals(0, result.size());
    }

    @isTest
    static void TestSaveQuestionAnswers() {
        // Arrange
        Question_Answer_Option__c insertedQuestionAnswer = VotingDataFactory.createQuestionsWithAnswer();

        Question_Answer_Option__c newQuestionAnswer = new Question_Answer_Option__c(
            Question_Id__c = insertedQuestionAnswer.Question_Id__c,
            Answer_Option_Id__c = insertedQuestionAnswer.Answer_Option_Id__c
        );

        List<Question_Answer_Option__c> newQuestionAnswers = new List<Question_Answer_Option__c>{ newQuestionAnswer };
        
        // Act
        QuestionController.saveQuestionAnswers(newQuestionAnswers, insertedQuestionAnswer.Question_Id__c);

        // Assert
        List<Question_Answer_Option__c> populatedQuestionAnswers = [
            SELECT Id, Name
            FROM Question_Answer_Option__c
        ];
        System.assertNotEquals(0, populatedQuestionAnswers.size());
        System.assertNotEquals(insertedQuestionAnswer.Name, populatedQuestionAnswers[0].Name);
    }

    @isTest
    static void TestGetQuestionBySurvey() {
        // Arrange
        Survey_Question__c insertedSurveyQuestion = VotingDataFactory.createSurveyWithQuestion();

        // Act
        List<SObject> questions = QuestionController.getQuestionBySurvey(insertedSurveyQuestion.Survey_Id__c);

        // Assert
        System.assertEquals(1, questions.size());
    }

    @isTest
    static void TestSaveSurveyQuestions() {
        // Arrange
        Survey_Question__c insertedSurveyQuestion = VotingDataFactory.createSurveyWithQuestion();

        Survey_Question__c newSurveyQuestion = new Survey_Question__c(
            Question_Id__c = insertedSurveyQuestion.Question_Id__c,
            Survey_Id__c = insertedSurveyQuestion.Survey_Id__c
        );

        List<Survey_Question__c> newSurveyQuestions = new List<Survey_Question__c>{ newSurveyQuestion };
        
        // Act
        QuestionController.saveSurveyQuestions(newSurveyQuestions, insertedSurveyQuestion.Survey_Id__c);

        // Assert
        List<Survey_Question__c> populatedSurveyQuestions = [
            SELECT Id, Name
            FROM Survey_Question__c
        ];
        System.assertNotEquals(0, populatedSurveyQuestions.size());
        System.assertNotEquals(insertedSurveyQuestion.Name, populatedSurveyQuestions[0].Name);
    }
}
