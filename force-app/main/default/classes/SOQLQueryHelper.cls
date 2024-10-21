public inherited sharing class SOQLQueryHelper {

    public static List<Contact> getContactsByIdsSet(Set<Id> contactIds){
        return [SELECT Id,FirstName FROM Contact WHERE Id IN :contactIds];
    }

    public static List<Program__c> getProgramsByIdSet(Set<Id> programIds){
        return [SELECT Id, Name FROM Program__c WHERE Id IN :programIds];
    }

    public static List<Program_Assignment__c> programAssignmentsWithAutonameTrue(Set<Id> programsIds){
        return [
            SELECT Name,Id FROM Program_Assignment__c 
            WHERE Program__c IN :programsIds AND Autoname__c = true
        ];
    }

    public static List<Program_Assignment__c> programAssignmentsWithAnyStatusExceptDeniedOrApplied(){
        return [
            SELECT Id, Program__c 
            FROM Program_Assignment__c 
            WHERE Status__c NOT IN ('Denied' ,'Applied')
        ];
    }

    public static List<Program_Assignment__c> programAssignmentsWithoutProgram(Set<Id> programsIds){
        return [
            SELECT Id FROM Program_Assignment__c 
            WHERE Program__c IN :programsIds 
        ];
    }

    public static List<Lead> getAllLeadsAndFewParamFromOutreach(){
        List<Lead> leadsList = new List<Lead> ([
            SELECT Id,Name,Outreaches_count__c,Successful_Outreaches__c,(SELECT Name,Outcome__c FROM Outreachs__r) 
            FROM Lead
            ]);
            return leadsList;
    }
}