public with sharing class ProgramAssignmentController {

    @AuraEnabled
    public static List<Service_Delivery__c> getServiceDeliveryByPAId(Id id){
        try {
            System.debug('recordId in Apex: ' + id);
            
            List<Service_Delivery__c> deliveryServices = [
                SELECT Id,Name,Billable__c,Contact__c,Duration__c,Service_Date__c,Service_Name__c,Short_Description__c
                FROM Service_Delivery__c
                WHERE Program_Assignment__c = :id
            ];
            System.debug('logLevel : ' + deliveryServices);
            
            return deliveryServices;
        }
        catch(Exception e){
            System.debug('Error in Apex: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static void updateServiceDeliveryRecords(List<Service_Delivery__c> serviceDeliveries){
        try {
            System.debug('Service Deliveries : ' + serviceDeliveries);
            
            update serviceDeliveries;
            
            System.debug('updated');
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}