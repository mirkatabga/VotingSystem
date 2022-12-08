@IsTest
public with sharing class AssignmentsTests {
    @IsTest
    static void Constructor_AllSet_AllPropertiesShouldBeSet(){
        
        Test.startTest();

        Assignments assignments = new Assignments(
            new List<Id>{ Id.valueOf('0057S00000143O5QAI')},
            new List<Id>{ Id.valueOf('1057S00000143O5QAI')},
            new List<Id>{ Id.valueOf('2057S00000143O5QAI')},
            new List<Id>{ Id.valueOf('3057S00000143O5QAI')});

        System.assert(assignments.Voters.size() > 0);
        System.assert(assignments.Moderators.size() > 0);
        System.assert(assignments.Configurators.size() > 0);
        System.assert(assignments.Analysts.size() > 0);

        Test.stopTest();      
    }

    @IsTest
    static void Constructor_OnlyAnalystsNull_OnlyAnalystsShouldBeNull(){
        
        Test.startTest();

        Assignments assignments = new Assignments(
            new List<Id>{ Id.valueOf('0057S00000143O5QAI')},
            new List<Id>{ Id.valueOf('1057S00000143O5QAI')},
            new List<Id>{ Id.valueOf('2057S00000143O5QAI')},
            null);

        System.assert(assignments.Voters.size() > 0);
        System.assert(assignments.Moderators.size() > 0);
        System.assert(assignments.Configurators.size() > 0);
        System.assert(assignments.Analysts == null);

        Test.stopTest();      
    }

    @IsTest
    static void GetUserTypesForAvailableData_NoData_ReturnsEmpty(){
        
        Test.startTest();
        Assignments assignments = new Assignments(null, null, null, null);

        List<String> userTypes = assignments.GetUserTypesForAvailableData();

        System.assert(userTypes.isEmpty());
        Test.stopTest();        
    }

    @IsTest
    static void GetUserTypesForAvailableData_OnlyOne_ReturnsExpectedUserType(){
        
        Test.startTest();
        Assignments assignments = new Assignments(
            null, new List<Id>{ Id.valueOf('1057S00000143O5QAI')} , null, null);

        List<String> userTypes = assignments.GetUserTypesForAvailableData();

        System.assert(userTypes.size() == 1);
        System.assert(userTypes[0] == ApplicationConstants.MODERATOR_RECORD_TYPE_NAME);
        Test.stopTest();     
    }

    @IsTest
    static void GetUserTypesForAvailableData_OnlyOneEmpty_ReturnsExpectedUserType(){
        
        Test.startTest();
        Assignments assignments = new Assignments(
            null, null , new List<Id>(), null);

        List<String> userTypes = assignments.GetUserTypesForAvailableData();

        System.assert(userTypes.size() == 1);
        System.assert(userTypes[0] == ApplicationConstants.CONFIGURATOR_RECORD_TYPE_NAME);
        Test.stopTest();     
    }

    @IsTest
    static void GetUserTypesForAvailableData_All_ReturnsExpectedNumberOfUserTypes(){
        
        Test.startTest();

        Assignments assignments = new Assignments(
            new List<Id>{ Id.valueOf('0057S00000143O5QAI')},
            new List<Id>{ Id.valueOf('1057S00000143O5QAI')},
            new List<Id>{ Id.valueOf('2057S00000143O5QAI')},
            new List<Id>{ Id.valueOf('3057S00000143O5QAI')});

        List<String> userTypes = assignments.GetUserTypesForAvailableData();

        System.assert(userTypes.size() == 4);
        Test.stopTest();     
    }

    @IsTest
    static void GetUserIds_NonExistingUserType_ReturnsNull(){        
        Test.startTest();
        Assignments assignments = new Assignments(null, null, null, null);
        List<Id> userIds = assignments.GetUserIds('non-existing-user-campaign-record-type');

        System.assertEquals(null, userIds);
        Test.stopTest();    
    }

    @IsTest
    static void GetUserIds_ExistingUserType_ReturnsExpectedIds(){        
        Test.startTest();
        List<Id> expected = new List<Id>
        { 
            Id.valueOf('0057S00000143O5QAI'), 
            Id.valueOf('1057S00000143O5QAI')
        };

        Assignments assignments = new Assignments(
            expected, null, null, null);

        List<String> userTypes = assignments.GetUserTypesForAvailableData();
        List<Id> userIds = assignments.GetUserIds(userTypes[0]);

        System.assertEquals(expected, userIds);
        Test.stopTest();    
    }
}
