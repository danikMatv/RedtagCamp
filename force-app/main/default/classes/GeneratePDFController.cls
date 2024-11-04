public with sharing class GeneratePDFController {
    public List<ServiceDeliveryWrapper> serviceDeliveryWrapperList { get; set; }
    public String startDate { get; set; }
    public String endDate { get; set; }
    public Decimal overPrice { get; set; }

    public GeneratePDFController() {
        Id recordId = ApexPages.currentPage().getParameters().get('recordId');
        Date startDateForLoop = Date.valueOf(ApexPages.currentPage().getParameters().get('startDate'));
        Date endDateForLoop = Date.valueOf(ApexPages.currentPage().getParameters().get('endDate'));
        Boolean includeNonBillableSD = Boolean.valueOf(ApexPages.currentPage().getParameters().get('includeNonBillableSD'));

        startDate = startDateForLoop.format();
        endDate = endDateForLoop.format();
        System.debug('Start Date: ' + startDateForLoop);
        System.debug('End Date: ' + endDateForLoop);
        System.debug('Record Id: ' + recordId);
        
        List<Service_Delivery__c> serviceDeliveryList = new List<Service_Delivery__c>();
        serviceDeliveryWrapperList = new List<ServiceDeliveryWrapper>();
        
        Program_Assignment__c programAssignment = [
            SELECT Id, Name, Overall_price__c FROM Program_Assignment__c WHERE Id = :recordId LIMIT 1
        ];
        
        overPrice = programAssignment.Overall_price__c;
        
        if (!includeNonBillableSD) {
            serviceDeliveryList = [
            SELECT Id, Name, Billable__c, Contact__r.Name, Duration__c, Service_Date__c,Delivery_Price__c, Service_Name__c
            FROM Service_Delivery__c 
            WHERE Program_Assignment__c = :recordId
            AND Service_Date__c > :startDateForLoop
            AND Service_Date__c < :endDateForLoop
            ];    
        }
        else{
        serviceDeliveryList = [
                SELECT Id, Name, Billable__c, Contact__r.Name, Duration__c, Service_Date__c,Delivery_Price__c, Service_Name__c
                FROM Service_Delivery__c 
                WHERE Program_Assignment__c = :recordId
                AND Service_Date__c > :startDateForLoop
                AND Service_Date__c < :endDateForLoop
            ];
        }
        
        System.debug('servicrDel: ' + serviceDeliveryList.size());
        Decimal overallDuration = 0;
        for (Service_Delivery__c sd : serviceDeliveryList) {
            if (sd.Duration__c != null) {
                overallDuration += sd.Duration__c;
            }
        }

        System.debug(' : ' + serviceDeliveryList.size());    
        
        Decimal pricePerMin = calculatePricePerMin(overallDuration, overPrice);
        Decimal price = 0;
        if (overallDuration > 0 && overPrice != null) {
            for (Service_Delivery__c sd : serviceDeliveryList) {
                if(sd.Billable__c){
                    price = (sd.Duration__c * pricePerMin);
                    System.debug('price: ' + price);
                    serviceDeliveryWrapperList.add(new ServiceDeliveryWrapper(sd,price.intValue()));
                }
            }
        }
        System.debug('pricePerMIn: ' + pricePerMin);
        System.debug('Service Delivery List Size: ' + serviceDeliveryList.size());
        System.debug('serviceDeliveryWrapperList List Size: ' + serviceDeliveryWrapperList.size());
    
    }
    private Decimal calculatePricePerMin(Decimal duration, Decimal overPrice) {
        return overPrice / (duration);
    }
}
