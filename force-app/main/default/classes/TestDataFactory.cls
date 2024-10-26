@isTest
public class TestDataFactory {


    public static Program__c createProgram(String Name,String Type){
        Program__c program = new Program__c(Name = Name,Type__c = Type);
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

    public static Contact createContactByFirstAndLastName(String firstName, String LastName){
        Contact contact = new Contact(FirstName = firstName,LastName = LastName);
        insert contact;
        return contact;
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

    public static Lead generateLead(){
        Lead lead = new Lead(
            LastName = 'Test Lead',
            Company = 'Test Company',
            Need_Attention__c = false,
            OwnerId = UserInfo.getUserId()
        );
        return lead;
    }

    public static Outreach__c generateOutreach(Lead lead){
        Outreach__c outreach = new Outreach__c(
            Lead__c = lead.Id,
            Outcome__c = 'Declined',
            Communication_Method__c = 'Phone'
        );
        return outreach;
    }

    public static List<Outreach__c> generateOutreaches(Lead lead,Integer quantity){
        List<Outreach__c> outreaches = new List<Outreach__c>();
        for(Integer i=0; i<quantity; i++){
            outreaches.add(generateOutreach(lead));
        }
        return outreaches;
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
    
    public static Program_Assignment__c createProgramAssignmentWithEnteredContactAndProgramAndInsert(Program__c program,Contact contact){
        Program_Assignment__c newProgramAssign = new Program_Assignment__c(
            Name = '', 
            Program__c = program.Id, 
            Contact__c = contact.Id,
            Start_Date__c = Date.newInstance(2024, 12, 20)
        );
        insert newProgramAssign;
        return newProgramAssign;
    }
}