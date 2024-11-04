public with sharing class ServiceDeliveryWrapper {
    public Service_Delivery__c serviceDelivery {get;set;}
    public String price {get;set;}

    public ServiceDeliveryWrapper(Service_Delivery__c serviceDel,Integer priceDel) {
        serviceDelivery = serviceDel;
        price = priceDel + '$';
    }
}