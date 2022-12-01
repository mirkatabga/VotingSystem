@isTest
public with sharing class AnswerControllerTests {
    @isTest
    static void TestGetPotentialAnswers() {
        // Arrange
        List<Answer_Option__c> createdAnswers = VotingDataFactory.createAnswers();

        // Act
        List<SObject> result = AnswerController.getPotentialAnswers();

        // Assert
        System.assertNotEquals(0, result.size());
    }

    @isTest
    static void TestGetAnswersByQuestion() {
        // Arrange
        Question_Answer_Option__c insertedQuestionAnswer = VotingDataFactory.createQuestionsWithAnswer();

        // Act
        List<SObject> answerQuestion = AnswerController.getAnswersByQuestion(insertedQuestionAnswer.Question_Id__c);

        // Assert
        System.assertEquals(1, answerQuestion.size());
    }
}
