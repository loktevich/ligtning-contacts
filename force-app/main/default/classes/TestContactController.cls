@isTest
public with sharing class TestContactController {
    public static List<Contact> createContacts(Integer amount, Integer startCount) {
        List<Contact> contacts = new List<Contact>();
        String contactLevel = 'Primary';
        for (Integer i = startCount; i <= amount; i++) {
            if (Math.mod(i, 2) == 0) {
                contactLevel = 'Secondary';
            } else if (Math.mod(i, 3) == 0) {
                contactLevel = 'Tertiary';
            }
            contacts.add(
                new Contact(
                    FirstName='First' + i,
                    LastName='Last' + i,
                    Email='email' + i + '@test.com',
                    Contact_Level__c=contactLevel
                    )
                );
        }
        return contacts;
    }

    @isTest static void testSearchAll() {
        List<Contact> testContacts = TestContactController.createContacts(9, 1);
        insert testContacts;
        String searchName = '';
        String sortedBy = 'Name';
        String sortDirection = 'asc';
        Integer pageNumber = 1;
        Integer pageSize = 10;
        String searchId = 'test';

        Test.startTest();
        PagedResult contacts = ContactController.searchContacts(searchName, sortedBy, sortDirection, pageNumber, pageSize, searchId);
        Test.stopTest();

        // The number of resulting contacts is 9
        System.assertEquals(9, contacts.records.size());
        System.assertEquals(9, contacts.totalRecords);
    }

    @isTest static void testSearchOneName() {
        List<Contact> testContacts = TestContactController.createContacts(9, 1);
        insert testContacts;
        String searchName = 'First1';
        String sortedBy = 'Name';
        String sortDirection = 'asc';
        Integer pageNumber = 1;
        Integer pageSize = 10;
        String searchId = 'test';

        Test.startTest();
        PagedResult contacts = ContactController.searchContacts(searchName, sortedBy, sortDirection, pageNumber, pageSize, searchId);
        Test.stopTest();

        // The number of resulting contacts is 1
        System.assertEquals(1, contacts.records.size());
        System.assertEquals(1, contacts.totalRecords);

        // The name is 'First1 Last1'
        List<SimpleContact> records = contacts.records;
        System.assertEquals('First1 Last1', records[0].Name);
    }

    @isTest static void testSearchManyNames() {
        List<Contact> testContacts = TestContactController.createContacts(11, 1);
        insert testContacts;
        String searchName = 'First1';
        String sortedBy = 'Name';
        String sortDirection = 'asc';
        Integer pageNumber = 1;
        Integer pageSize = 10;
        String searchId = 'test';

        Test.startTest();
        PagedResult contacts = ContactController.searchContacts(searchName, sortedBy, sortDirection, pageNumber, pageSize, searchId);
        Test.stopTest();

        // The number of resulting contacts is 2
        System.assertEquals(1, contacts.records.size());
        System.assertEquals(1, contacts.totalRecords);
        
        // The names are 'First1 Last1' and 'First11 Last11'
        List<SimpleContact> records = contacts.records;
        System.assertEquals('First1 Last1', records[0].Name);
        System.assertEquals('First11 Last11', records[1].Name);
    }

    @isTest static void testSearchNotExistedName() {
        List<Contact> testContacts = TestContactController.createContacts(3, 1);
        insert testContacts;
        String searchName = 'First5';
        String sortedBy = 'Name';
        String sortDirection = 'asc';
        Integer pageNumber = 1;
        Integer pageSize = 10;
        String searchId = 'test';

        Test.startTest();
        PagedResult contacts = ContactController.searchContacts(searchName, sortedBy, sortDirection, pageNumber, pageSize, searchId);
        Test.stopTest();

        // The number of resulting contacts is 0
        System.assertEquals(0, contacts.records.size());
        System.assertEquals(0, contacts.totalRecords);
    }

    @isTest static void testPagination() {
        List<Contact> testContacts = TestContactController.createContacts(9, 1);
        insert testContacts;
        String searchName = '';
        String sortedBy = 'Name';
        String sortDirection = 'asc';
        Integer pageNumber = 1;
        Integer pageSize = 3;
        String searchId = 'test';

        Test.startTest();
        PagedResult contacts = ContactController.searchContacts(searchName, sortedBy, sortDirection, pageNumber, pageSize, searchId);
        Test.stopTest();

        // The size of page is 3, total number is 9
        System.assertEquals(3, contacts.records.size());
        System.assertEquals(9, contacts.totalRecords);
    }

    @isTest static void testSorting() {
        List<Contact> testContacts = TestContactController.createContacts(9, 1);
        insert testContacts;
        String searchName = '';
        String sortedBy = 'Name';
        String sortDirection = 'desc';
        Integer pageNumber = 1;
        Integer pageSize = 10;
        String searchId = 'test';

        Test.startTest();
        PagedResult contacts = ContactController.searchContacts(searchName, sortedBy, sortDirection, pageNumber, pageSize, searchId);
        Test.stopTest();

        // The first record name 'First9 Last9'
        List<SimpleContact> records = contacts.records;
        System.assertEquals('First9 Last9', records[0].Name);
    }
}
