declare module "@salesforce/apex/ContactController.getContacts" {
  export default function getContacts(param: {sortedBy: any, sortDirection: any}): Promise<any>;
}
declare module "@salesforce/apex/ContactController.searchContacts" {
  export default function searchContacts(param: {searchName: any, sortedBy: any, sortDirection: any}): Promise<any>;
}
