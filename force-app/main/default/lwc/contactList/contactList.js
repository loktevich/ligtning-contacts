import { LightningElement, track } from 'lwc';
import searchContacts from '@salesforce/apex/ContactController.searchContacts';

const COLUMNS = [
    { label: 'Name', fieldName: 'NameLink', sortable: true, type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_blank' } },
    { label: 'Email', fieldName: 'Email', type: 'email', sortable: true },
    { label: 'Contact Level', fieldName: 'ContactLevel', sortable: true },
    { label: 'Account', fieldName: 'AccountName', sortable: true },
    { label: 'Owner', fieldName: 'OwnerName', sortable: true },
    { label: 'Created By', fieldName: 'CreatedBy', sortable: true },
    { label: 'Created Date', fieldName: 'CreatedDate', type: 'date', sortable: true },
    { fieldName: 'delete', type: 'button', initialWidth: 120, typeAttributes: { label: 'Delete', name: 'delete', iconName: 'utility:delete' } }
];

const DEFAULT_SORT_FIELD = 'Name';
const DEFAULT_SORT_DIRECTION = 'asc'
const PAGE_SIZE = 10;
const PAGE_NUMBER = 1;

export default class ContactList extends LightningElement {
    columns = COLUMNS;
    sortField = DEFAULT_SORT_FIELD;
    searchId = Date.now().toString();
    @track recordId;
    @track contacts;
    @track error;
    @track searchName = '';
    @track sortedBy = this.sortField;
    @track sortDirection = DEFAULT_SORT_DIRECTION;
    @track pageSize = PAGE_SIZE;
    @track pageNumber = PAGE_NUMBER;
    @track openModalWindow = false;
    @track confirmDelete = false;

    connectedCallback() {
        this.loadContacts();
    }

    loadContacts() {
        searchContacts({
            searchName: this.searchName,
            sortedBy: this.sortField,
            sortDirection: this.sortDirection,
            pageNumber: this.pageNumber,
            pageSize: this.pageSize,
            searchId: this.searchId
        })
            .then(result => {
                this.contacts = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.contacts = undefined;
            });
    }

    updateColumnSorting(event) {
        const sortDirection = event.detail.sortDirection;
        const fieldName = event.detail.fieldName;
        switch (fieldName) {
            case 'NameLink':
                this.sortField = 'Name';
                break;
            case 'ContactLevel':
                this.sortField = 'Contact_Level__c';
                break;
            case 'AccountName':
                this.sortField = 'Account.Name';
                break;
            case 'OwnerName':
                this.sortField = 'Owner.Name';
                break;
            case 'CreatedBy':
                this.sortField = 'CreatedBy.Name';
                break;
            default:
                this.sortField = fieldName;
                break;
        }

        this.sortDirection = sortDirection;
        this.sortedBy = fieldName;
        this.loadContacts();
    }

    updateSearchName(event) {
        this.searchName = event.target.value;
    }

    updateSearchId() {
        this.searchId = Date.now().toString();
    }

    searchByName() {
        this.loadContacts();
    }

    previousPage() {
        this.pageNumber--;
        this.loadContacts();
    }

    nextPage() {
        this.pageNumber++;
        this.loadContacts();
    }

    handleRowAction(event) {
        this.recordId = event.detail.row.Id;
        this.confirmDelete = true;
    }

    openModal() {
        this.openModalWindow = true;
    }

    closeAndUpdate() {
        this.openModalWindow = false;
        this.confirmDelete = false;
        this.updateSearchId();
        this.loadContacts();
    }

    closeModal() {
        this.openModalWindow = false;
        this.confirmDelete = false;
    }
}
