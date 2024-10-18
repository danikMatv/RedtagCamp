@isTest
public with sharing class ProgramAssignmentTriggerHandlerTest {
    
    @TestSetup
    static void makeData(){
        Program__c program = TestDataFactory.createProgram('Test','Help Program');
        Contact contact = TestDataFactory.createContactByFirstAndLastName('Test','Test Contact');
    }


    @isTest
    private static void beforeInsertTest(){
        Program__c program = [SELECT Name,Type__c FROM Program__c WHERE Name = 'Test' AND Type__c = 'Help Program' LIMIT 1];
        Contact contact = [SELECT FirstName,LastName FROM Contact WHERE FirstName = 'Test' AND LastName = 'Test Contact' LIMIT 1];
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
        Assert.areEqual('Test - Test : 20.12.2024', programAssignmentAfterInsert.Name,'name was not generated');
    }

    @isTest
    private static void beforeUpdateTest(){
        Program__c program = [SELECT Name,Type__c FROM Program__c WHERE Name = 'Test' AND Type__c = 'Help Program' LIMIT 1];
        Contact contact = [SELECT FirstName,LastName FROM Contact WHERE FirstName = 'Test' AND LastName = 'Test Contact' LIMIT 1];
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