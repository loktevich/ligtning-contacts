import { LightningElement, api } from 'lwc';

export default class Paginator extends LightningElement {

    @api pageNumber;
    @api pageSize;
    @api totalRecords;

    handlePrevious() {
        this.dispatchEvent(new Event('previous'));
    }

    handleNext() {
        this.dispatchEvent(new Event('next'));
    }

    get currentPageNumber() {
        return this.totalRecords === 0 ? 0 : this.pageNumber;
    }

    get isFirstPage() {
        return this.pageNumber === 1;
    }

    get isLastPage() {
        return this.pageNumber >= this.totalPages;
    }

    get totalPages() {
        return Math.ceil(this.totalRecords / this.pageSize);
    }
}