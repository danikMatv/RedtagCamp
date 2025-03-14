import { LightningElement, track, wire,api } from 'lwc';
import getAllProgramAssignmentsRelatedToContact from '@salesforce/apex/ProgramManagementClass.getAllProgramAssignmentsRelatedToContact';
import insertServiceDelivery from '@salesforce/apex/ProgramManagementClass.insertServiceDelivery'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { RefreshEvent } from "lightning/refresh";

export default class BulkSDCreateComponent extends LightningElement {
    currentStepIsOne = true;
    currentStepIsTwo = false;
    currentStepIsThree = false;
    currentStepIsFour = false;
    isSave = false;

    currentStep = 'step1';
    contactId;
    progAssignId;
    numRecordsToCreate = 1;
    
    @track itemList = [];
    @track statusOptions = [];

    @wire(getAllProgramAssignmentsRelatedToContact,{contactId: '$contactId'})
        wiredProgramAssignments(result) {
            if (result.data) {
                this.statusOptions = 
                result.data.map(contact => ({
                        label: contact.Name,
                        value: contact.Id
                }))
                console.log('statusOptions', this.statusOptions);
            }
        }

    

    handleClick() {
        switch (this.currentStep) {
            case 'step1':
                this.currentStep = 'step2';
                this.currentStepIsOne = false;
                this.currentStepIsTwo = true;
                break;
            case 'step2':
                this.currentStep = 'step3';
                this.currentStepIsTwo = false;
                this.currentStepIsThree = true;
                break;
            case 'step3':
                this.currentStep = 'step4';
                this.currentStepIsThree = false;
                this.currentStepIsFour = true;
                break;
        }
    }


    async handleChooseContact(event) {
        console.log('handleChooseContact event',event);
        this.contactId = event.detail.recordId;
        console.log(this.contactId);

        console.log('ProgramAssignments',statusOptions);
    }

    handleSChooseProgramAssignment(event) {
        console.log('handleSChooseProgramAssignment event',event);
        this.progAssignId = event.detail.value;
        console.log(this.progAssignId);
    }

    refreshHandle() {
        this.currentStep = 'step1';
        this.currentStepIsFour = false;
        this.currentStepIsOne = true; 
        this.contactId = null;
        this.progAssignId = null;
        this.dispatchEvent(new RefreshEvent())
    }
   showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    addRow(){
        if (this.contactId && this.progAssignId) {
            const newRecord = {
                id: this.itemList.length,
                Contact__c: this.contactId,
                Program_Assignment__c: this.progAssignId,
                Service_Name__c: '',
                Service_Date__c: '',
                Duration__c: 0,
                Billable__c: false
            };
            this.itemList = [...this.itemList, newRecord];
        } else {
            console.error('Contact ID or Program Assignment ID is not set.');
        }
    }
    

    handleInputChange(event){
        const fieldName = event.target.name;
        const fieldValue = event.detail.value;
        const index = event.target.getAttribute('data-id');
        const record = {...this.itemList[index]};
        record[fieldName] = fieldValue;
        console.log(record);
        this.itemList[index] = record;
        console.log(this.itemList);
    }

    removeRow(event){
        const index = event.target.getAttribute('data-id');
        this.itemList.splice(index,1);
    }

    async handleSubmit() {
        for (const record of this.itemList){
            if(!record.Service_Name__c || !record.Service_Date__c || !record.Duration__c){
                this.dispatchEvent(
                    new ShowToastEvent({
                    title:'Error',
                    message:'Please fill all required fields',
                    variant:'error'})
                );
                return;
            }
        }
            this.isSave = true;
        this.dispatchEvent(
            new ShowToastEvent({
            title:'Success',
            message:'Service Delivery updated',
            variant:'success'})
        );
        const itemListToSave = this.itemList.map(({ id, ...record }) => record);
        await insertServiceDelivery({serviceDeliveryList: itemListToSave});
        this.itemList = [];
        this.currentStep = 'step4';
        this.currentStepIsFour = true;
        this.currentStepIsOne = false;    
    
    }

}