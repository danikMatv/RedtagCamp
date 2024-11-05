import { LightningElement,track,wire,api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import savePdf from '@salesforce/apex/ProgramAssignmentController.savePdf';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class GeneratePdfInProgramAssignment extends LightningElement {
    startDate = 0;
    endDate = 0;
    includeNonBillableSD = false;
    currentStep = 1;
    currentStepIsOne=true
    currentStepIsTwo=false
    successfull = false;

    @api recordId;

    url = '';
    connectedCallback(){
        console.log('connectedCallback');
        console.log(this.recordId);
    }
    

    @track reportParams=[
        {
            startDate:'',
            endDate:'',
            includeNonBillableSD:false
        }
    ];

    handleClick() {
        this.currentStep = 2;
        this.currentStepIsOne=false
        this.currentStepIsTwo=true
    }

    handleInputChange(event){
        if(event?.currentTarget?.name == 'includeNonBillableSD'){
            this.reportParams[0].includeNonBillableSD = event?.currentTarget?.checked;
        }
        else{
            this.reportParams[0][event?.currentTarget?.name] = event?.currentTarget?.value;            
        }
    }

    handleClose(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    async handleGeneratePreview(){
        console.log(this.recordId);
        
        this.url = `/apex/generatePDF?recordId=${this.recordId}&endDate=${this.reportParams[0].endDate}&startDate=${this.reportParams[0].startDate}&includeNonBillableSD=${this.reportParams[0].includeNonBillableSD}`;
        content:window.open(this.url, '_blank')
        
    }

    async handleGeneratePDF(event){
        this.url = `/apex/generatePDF?recordId=${this.recordId}&endDate=${this.reportParams[0].endDate}&startDate=${this.reportParams[0].startDate}&includeNonBillableSD=${this.reportParams[0].includeNonBillableSD}`;
        console.log(this.url);
        try {
            const result = await savePdf({url: this.url, recordId: this.recordId ,endDate : this.reportParams[0].endDate, startDate: this.reportParams[0].startDate});
            console.log(result);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'PDF Generated Successfully',
                    variant: 'success',
                }),
            )
            this.dispatchEvent(new CloseActionScreenEvent());
        } catch (error) {
            console.error('Error generating PDF: ', error);
        }
    }
}