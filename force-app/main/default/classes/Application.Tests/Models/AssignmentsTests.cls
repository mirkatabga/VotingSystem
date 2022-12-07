@IsTest
public with sharing class AssignmentsTests {
    @IsTest
    static void Voters_WhenSet_ShouldNotBeNull(){
        
        Test.startTest();
        Assignments assignments = new Assignments(
            new List<Id>{ Id.valueOf('0057S00000143O5QAI')},
            null,
            null,
            null);

        System.assert(assignments.Voters != null);
        Test.stopTest();      
    }    
}
