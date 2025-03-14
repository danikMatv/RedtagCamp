@isTest
public class ProgramTriggerHandlerTest {
    
    @TestSetup
    static void makeData(){
        Program__c program = TestDataFactory.createProgram('Test','Help Program');
        Contact contact = TestDataFactory.createContactByFirstAndLastName('Test','Test Contact');
    }

    @isTest
    static void TestProgramTriggerAfterUpdate(){
        Program__c program = [SELECT Name,Type__c FROM Program__c WHERE Name = 'Test' AND Type__c = 'Help Program' LIMIT 1];
        List<Program_Assignment__c> programAssignments = TestDataFactory.createProgramAssignment(program,2);

        Test.startTest();

        Program__c updatedProgram1 = [SELECT Id, Name FROM Program__c WHERE Id =:program.Id LIMIT 1];
        updatedProgram1.Name = 'new Test 1';
        update updatedProgram1;

        Test.stopTest();
        
        List<Program_Assignment__c> updatedAssignments = [
            SELECT Name, Program__c 
            FROM Program_Assignment__c 
            WHERE Program__c =:updatedProgram1.Id
        ];
        for (Program_Assignment__c pA : updatedAssignments) {
            System.assertEquals('Mykhailo Mudryk', pA.Name, 'Program Assignment name was not updated correctly.');
        }
    }


    @isTest
    static void TestBeforeDeleteDelRelatedProgramAssignments() {
        Program__c program = [SELECT Name,Type__c FROM Program__c WHERE Name = 'Test' AND Type__c = 'Help Program' LIMIT 1];
        List<Program_Assignment__c> programAssignments = TestDataFactory.createProgramAssignment(program, 2);

        Test.startTest();
        
        delete program;

        Test.stopTest();
        List<Program_Assignment__c> relatedAssignments = [
            SELECT Name, Program__c 
            FROM Program_Assignment__c 
            WHERE Program__c =:program.Id
        ];

        System.assertEquals(0, relatedAssignments.size(), 'Program Assignments were not deleted.');
    }

    @isTest
    static void TestBeforeDeleteExeptionIfChildNotAvailableForDelete() {
        Program__c program = [SELECT Name,Type__c FROM Program__c WHERE Name = 'Test' AND Type__c = 'Help Program' LIMIT 1];
        Program_Assignment__c programAssignment = TestDataFactory.createProgramAssing(program);

        Test.startTest();
            try {
                delete program;
                System.assert(false, 'Expected an error to be thrown when deleting a program with an applied assignment');
            } catch (DmlException e) {
                System.assert(e.getMessage().contains('Nope'), 'Error message not as expected: ' + e.getMessage());
            }
        Test.stopTest();
    }
}