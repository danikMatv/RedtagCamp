import { LightningElement,wire,track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions'
import headerLwc from "@salesforce/label/c.LWC_Header_for_Quick_Action_in_Program_Assignment"
import updateServiceDeliveryRecords from '@salesforce/apex/ProgramAssignmentController.updateServiceDeliveryRecords';
import getServiceDeliveryByPAId from '@salesforce/apex/ProgramAssignmentController.getServiceDeliveryByPAId';

const columns = [
    { label: 'Name', fieldName: 'Name', editable: false },
    { label: 'Service Name', fieldName: 'Service_Name__c', type: 'text', editable: false },
    { label: 'Program Assignment', fieldName: 'Program_Assignment__c', type: 'text', editable: false },
    { label: 'Service Date', fieldName: 'Service_Date__c', type: 'date', editable: true },
    { label: 'Billable', fieldName: 'Billable__c', type: 'boolean', editable: true },
    { label: 'Duration', fieldName: 'Duration__c', type: 'number', editable: true },
    { label: 'Short Description', fieldName: 'Short_Description__c', type: 'text', editable: true },
    { label: 'Contact', fieldName: 'Contact__c', type: 'text', editable: false },
];

export default class BulkSDEditComponent extends LightningElement {
    recordId;
    @track ServiceDeliveryList = [];
    columns = columns;
    headerLwc = headerLwc;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            console.log('currentPageReference ', currentPageReference);
            this.recordId = currentPageReference.state.recordId;
            this.getData();
        }
    }

    getData(){
        console.log('currentPageReference ', this.recordId);
        getServiceDeliveryByPAId({id: this.recordId}).then(result => {
            this.ServiceDeliveryList = result;
            console.log('test', this.ServiceDeliveryList);
        }).catch(error => {
            console.log(error);
        });
    }

    handleSave(event){
        const updatedFields = event.detail.draftValues;
        console.log('updatedFields : ',updatedFields);
        console.log('2 : ',event);

        updateServiceDeliveryRecords({
            serviceDeliveries: updatedFields,
        }).then(result => {
            this.getData();
            this.dispatchEvent(
                new ShowToastEvent({
                title:'Success',
                message:'Service Delivery updated',
                variant:'success'})
            );
            this.dispatchEvent(new CloseActionScreenEvent());
        }).catch(error => {
            console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error',
                    mode: 'sticky' 
                })
            );
        });
    }

    handleCancel(event) {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

}