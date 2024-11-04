import { LightningElement, api, track } from 'lwc';
import getRelatedPDF from '@salesforce/apex/ProgramAssignmentController.getRelatedPDF';

export default class ShowPDFComponent extends LightningElement {
    @api recordId;
    @track attList = [];
    showPDF = false;

    handleClick() {
        this.showPDF = !this.showPDF;
        if (this.showPDF) {
            this.loadPDFs();
        }
    }

    async loadPDFs() {
        try {
            const pdfDocuments = await getRelatedPDF({ recordId: this.recordId });
            this.attList = pdfDocuments.map(doc => ({
                id: doc.Id,
                name: doc.Title,
                url: `/sfc/servlet.shepherd/version/download/${doc.LatestPublishedVersionId}`
            }));
        } catch (error) {
            console.error('Error loading PDFs:', error);
        }
    }
    
}
