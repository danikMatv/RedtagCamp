@isTest
public with sharing class ProgramAssignmentTriggerHandlerTest {
    
    @isTest
    private static void beforeInsertTest(){
        Program__c program = TestDataFactory.createProgram();
        Contact contact = new Contact(LastName = 'Test' , FirstName = 'Test Contact');
        insert contact;
        Program_Assignment__c programAssignment = TestDataFactory.createProgramAssignmentWithEnteredContactAndProgram(program,contact);

        Test.startTest();
        
            insert programAssignment;
        
        Test.stopTest();

        Program_Assignment__c programAssignmentAfterInsert = [
            SELECT Id,Name 
            FROM Program_Assignment__c
            WHERE Id =:programAssignment.Id
            LIMIT 1
            ];
        Assert.areEqual('Test Contact - Test : 20.12.2024', programAssignmentAfterInsert.Name,'name was not generated');
    }

    @isTest
    private static void beforeUpdateTest(){
        Program__c program = TestDataFactory.createProgram();
        
        Contact contact = new Contact(LastName = 'Test' , FirstName = 'Test Contact');
        insert contact;
        
        Program_Assignment__c programAssignment = TestDataFactory.createProgramAssignmentWithEnteredContactAndProgram(program,contact);
        insert programAssignment;
        
        Contact contactNew = new Contact(LastName = 'QA' , FirstName = 'QA');
        insert contactNew;
        
        programAssignment.Contact__c = contactNew.Id;

        Test.startTest();
        
        update programAssignment;
        
        Test.stopTest();

        Program_Assignment__c programAssignmentAfterInsert = [
            SELECT Id,Name 
            FROM Program_Assignment__c
            WHERE Id =:programAssignment.Id
            LIMIT 1
            ];
        Assert.areEqual('QA - Test : 20.12.2024', programAssignmentAfterInsert.Name,'name was not generated');
    }

}