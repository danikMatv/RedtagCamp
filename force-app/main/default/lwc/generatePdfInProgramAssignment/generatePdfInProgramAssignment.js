import { LightningElement,track,wire,api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';


export default class GeneratePdfInProgramAssignment extends LightningElement {
    startDate = 0;
    endDate = 0;
    includeNonBillableSD = false;

    @api recordId;

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
    currentStep = 1;
    currentStepIsOne=true
    currentStepIsTwo=false

    handleClick() {
        this.currentStep = 2;
        this.currentStepIsOne=false
        this.currentStepIsTwo=true
    }

    handleInputChange(event){
        console.log(event.currentTarget.name);
        console.log(event.currentTarget.value);
        this.reportParams[event?.currentTarget?.name] = event?.currentTarget?.value;
        console.log(this.reportParams);
    }

    handleClose(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    async handleGeneratePreview(){
        console.log(this.recordId);
        
        const url = `/apex/generatePDF?recordId=${this.recordId}&endDate=${this.reportParams.endDate}&startDate=${this.reportParams.startDate}&includeNonBillableSD=${this.reportParams.includeNonBillableSD}`;
        content:window.open(url, '_blank')
        
    }

    handleGeneratePDF(event){
        
    }
}