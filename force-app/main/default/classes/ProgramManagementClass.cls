public with sharing class ProgramManagementClass {
    
    @AuraEnabled(cacheable=true)
    public static List<Program_Assignment__c> getAllProgramAssignmentsRelatedToContact(String contactId){
        try {
            return [
                SELECT Id,Name 
                FROM Program_Assignment__c
                WHERE Contact__c = :contactId
            ];
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void insertServiceDelivery(List<Service_Delivery__c> serviceDeliveryList){
        try {
            insert serviceDeliveryList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}