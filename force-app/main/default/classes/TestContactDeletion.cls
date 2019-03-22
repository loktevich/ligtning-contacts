@isTest
public with sharing class TestContactDeletion {
    @isTest static void testCasesDeletion() {
        List<Contact> testContacts = TestContactController.createContacts(1, 1);
        Contact testContact = testContacts[0];
        insert testContact;

        Test.startTest();
        Database.DeleteResult result = Database.delete(testContact);
        Test.stopTest();

        // Deletion success
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);

        // All cases are deleted
        List<Case> cases = [SELECT Id FROM Case];
        System.assertEquals(0, cases.size());
    }
}
