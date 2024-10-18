public with sharing class ProgramAssignmentHelper {
    
    public static Program_Assignment__c generateNameAndAddToObject(Program_Assignment__c pA,Contact contact, Program__c program){
        if(contact != null && program != null){
            if(contact.Name != null && program.Name != null && pA.Start_Date__c != null){
                pA.Name = contact.Name + ' - ' + program.Name + ' : ' +  pA.Start_Date__c.format();
            }
            else {
                pA.Name = 'Mykhailo Mudryk ';  
            }
            return pA;
        }
        return pA;
    }
}