@isTest
public class TestDataFactory {


    public static Program__c createProgram(){
        Program__c program = new Program__c(Name = 'Test',Type__c = 'Help Program');
        insert program;
        return program;
    }

    public static List<Program_Assignment__c> createProgramAssignment(Program__c program, Integer numProgAssPerProgram) {
        List<Program_Assignment__c> programAssignments = new List<Program_Assignment__c>();
        
        Contact contact = new Contact(LastName = 'Test Contact');
        insert contact;

        for (Integer j = 0; j < numProgAssPerProgram; j++) {
            Program_Assignment__c newProgramAssign = new Program_Assignment__c(
                Name = '', 
                Program__c = program.Id, 
                Contact__c = contact.Id
            );
            programAssignments.add(newProgramAssign);
        }
        
        insert programAssignments;
        
        return programAssignments;
    }

    public static Program_Assignment__c createProgramAssing(Program__c program) {
        Contact contact = new Contact(LastName = 'Test Contact');
        insert contact;
        Program_Assignment__c newProgramAssign = new Program_Assignment__c(
            Name = '', 
            Program__c = program.Id, 
            Contact__c = contact.Id,
            Status__c = 'Completed'
        );
        
        insert newProgramAssign;
        
        return newProgramAssign;
    }

    public static Program_Assignment__c createProgramAssignmentWithEnteredContactAndProgram(Program__c program,Contact contact){
        Program_Assignment__c newProgramAssign = new Program_Assignment__c(
            Name = '', 
            Program__c = program.Id, 
            Contact__c = contact.Id,
            Start_Date__c = Date.newInstance(2024, 12, 20)
        );
        
        return newProgramAssign;
    }
    
}