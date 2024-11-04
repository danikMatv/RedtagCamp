import { LightningElement,track,wire,api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import savePdf from '@salesforce/apex/ProgramAssignmentController.savePdf';

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
        this.reportParams[event?.currentTarget?.name] = event?.currentTarget?.value;
    }

    handleClose(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    async handleGeneratePreview(){
        console.log(this.recordId);
        
        this.url = `/apex/generatePDF?recordId=${this.recordId}&endDate=${this.reportParams.endDate}&startDate=${this.reportParams.startDate}&includeNonBillableSD=${this.reportParams.includeNonBillableSD}`;
        content:window.open(this.url, '_blank')
        
    }

    async handleGeneratePDF(event){
        this.url = `/apex/generatePDF?recordId=${this.recordId}&endDate=${this.reportParams.endDate}&startDate=${this.reportParams.startDate}&includeNonBillableSD=${this.reportParams.includeNonBillableSD}`;
        console.log(this.url);
        try {
            const result = await savePdf({url: this.url, recordId: this.recordId ,endDate : this.reportParams.endDate, startDate: this.reportParams.startDate});
            console.log(result);
            this.successful = true;
        } catch (error) {
            console.error('Error generating PDF: ', error);
        }
    }
}