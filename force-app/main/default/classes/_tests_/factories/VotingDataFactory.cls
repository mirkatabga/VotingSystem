@IsTest
public with sharing class VotingDataFactory {
    public static User_Campaign__c creatCampaignWithUsers() {
        Campaign__c testCampaign = new Campaign__c(Name = 'Test Campaign');
        insert testCampaign;

        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User testUser = new User(
            Alias = 'standt',
            Email = 'testing@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testUserCampaign@testorg.com',
            ProfileId = testProfile.Id
        );
        insert testUser;

        User_Campaign__c userCampaign = new User_Campaign__c(
            Name = 'Test User Campaign',
            Campaign_Id__c = testCampaign.Id,
            User_Id__c = testUser.Id
        );
        insert userCampaign;

        return userCampaign;
    }

    public static List<Location__c> createLocations() {
        Location__c firstLocation = new Location__c(Name = 'First Location', Address__c = 'First Address');
        Location__c secondLocation = new Location__c(Name = 'Second Location', Address__c = 'Second Address');

        List<Location__c> locationList = new List<Location__c>{ firstLocation, secondLocation };
        insert locationList;

        return locationList;
    }

    public static List<Question__c> createQuestions() {
        Question__c firstQuestion = new Question__c(Name = 'First Question', Question_Text__c = 'First Test Question Text');
        Question__c secondQuestion = new Question__c(Name = 'Second Question', Question_Text__c = 'Second Test Question Text');

        List<Question__c> questionList = new List<Question__c>{ firstQuestion, secondQuestion };
        insert questionList;

        return questionList;
    }

    public static List<Answer_Option__c> createAnswers() {
        Answer_Option__c firstAnswer = new Answer_Option__c(Name = 'First Answer', Anwer_Option_Text__c = 'First Answer');
        Answer_Option__c secondAnswer = new Answer_Option__c(Name = 'Second Answer', Anwer_Option_Text__c = 'Second Answer');

        List<Answer_Option__c> answerList = new List<Answer_Option__c>{ firstAnswer, secondAnswer };
        insert answerList;

        return answerList;
    }

    public static Question_Answer_Option__c createQuestionsWithAnswer() {
        Question__c testQuestion = new Question__c(Name = 'First Question', Question_Text__c = 'First Test Question Text');
        insert testQuestion;

        Answer_Option__c testAnswer = new Answer_Option__c(Name = 'First Answer', Anwer_Option_Text__c = 'First Answer');
        insert testAnswer;

        Question_Answer_Option__c testQuestionAnswer = new Question_Answer_Option__c(
            Question_Id__c = testQuestion.Id,
            Answer_Option_Id__c = testAnswer.Id
        );
        insert testQuestionAnswer;

        return testQuestionAnswer;
    }

    public static Survey_Question__c createSurveyWithQuestion() {
        Campaign__c testCampaign = new Campaign__c(Name = 'Test Campaign');
        insert testCampaign;

        Question__c testQuestion = new Question__c(Name = 'First Question', Question_Text__c = 'First Test Question Text');
        insert testQuestion;

        Survey__c testSurvey = new Survey__c(Campaign_Id__c = testCampaign.Id, Name = 'First Survey');
        insert testSurvey;

        Survey_Question__c testSurveyQuestion = new Survey_Question__c(
            Question_Id__c = testQuestion.Id,
            Survey_Id__c = testSurvey.Id
        );
        insert testSurveyQuestion;

        return testSurveyQuestion;
    }

    public static Campaign_Location__c createCampaingWithLocation() {
        Campaign__c testCampaign = new Campaign__c(Name = 'Test Campaign');
        insert testCampaign;

        Location__c testLocation = new Location__c(Name = 'First Location', Address__c = 'First Address');
        insert testLocation;

        Campaign_Location__c testCampaingLocation = new 	Campaign_Location__c(
            Campaign_Id__c = testCampaign.Id,
            Location_Id__c = testLocation.Id
        );
        insert testCampaingLocation;

        return testCampaingLocation;
    }
}
