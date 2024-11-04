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

    @AuraEnabled
    public static String savePdf(String url, String recordId,String endDate,String startDate) {
        PageReference pdfPage = new PageReference(url);
        Blob pdf = pdfPage.getContentAsPDF();
        
        try {
            ContentVersion contentVersion = new ContentVersion();
            contentVersion.Title = 'Service Delivery Report ' + 'period : ' + startDate + ' - '  + endDate;
            contentVersion.PathOnClient = 'ServiceDeliveryReport.pdf';
            contentVersion.VersionData = pdf;
            contentVersion.FirstPublishLocationId = recordId;
            insert contentVersion;
            return 'PDF created';
        } catch (Exception e) {
            throw new AuraHandledException('PDF generation failed: ' + e.getMessage());
        }
    }


    @AuraEnabled
    public static List<ContentDocument> getRelatedPDF(String recordId) {
        List<ContentDocumentLink> documentLinks = [
            SELECT ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :recordId
        ];
        Set<Id> documentIds = new Set<Id>();
        for (ContentDocumentLink link : documentLinks) {
            documentIds.add(link.ContentDocumentId);
        }
        List<ContentDocument> pdfDocuments = [
            SELECT Id, Title, LatestPublishedVersionId
            FROM ContentDocument
            WHERE Id IN :documentIds
        ];
        return pdfDocuments;
    }

}