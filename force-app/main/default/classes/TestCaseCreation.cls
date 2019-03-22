@isTest
public with sharing class TestCaseCreation {
    
    @isTest static void testForContactsWithoutAccounts() {
        List<Contact> testContacts = TestContactController.createContacts(2, 1);

        Test.startTest();
        List<Database.SaveResult> result = Database.insert(testContacts);
        Test.stopTest();

        List<Case> cases = [SELECT OwnerId FROM Case];
        
        // Two cases
        System.assertEquals(2, cases.size());
        System.assert(result[0].isSuccess());
        System.assert(result[0].getErrors().size() == 0);
    }

    @isTest static void testForContactsWithAccounts() {
        List<Contact> testContacts = TestContactController.createContacts(2, 1);
        Account acct = new Account(Name='Test Account');
        User owner = [SELECT Id FROM USER LIMIT 1];
        acct.OwnerId = owner.Id;
        insert acct;
        for(Contact contact : testContacts) {
            contact.AccountId=acct.Id;
        }

        Test.startTest();
        List<Database.SaveResult> result = Database.insert(testContacts);
        Test.stopTest();

        List<Case> cases = [SELECT ContactId, AccountId, Status, Origin, OwnerId FROM Case];
        
        // Two cases
        System.assertEquals(2, cases.size());
        System.assert(result[0].isSuccess());
        System.assert(result[0].getErrors().size() == 0);

        // Test fields
        System.assertEquals(testContacts[0].Id, cases[0].ContactId);
        System.assertEquals(testContacts[0].AccountId, cases[0].AccountId);
        System.assertEquals('Working', cases[0].Status);
        System.assertEquals('New Contact', cases[0].Origin);
        System.assertEquals(acct.OwnerId, cases[0].OwnerId);
    }

    @isTest static void testPrimaryContact() {
        List<Contact> testContacts = TestContactController.createContacts(1, 1);
        Contact testContact = testContacts[0];

        Test.startTest();
        Database.SaveResult result = Database.insert(testContact);
        Test.stopTest();

        List<Case> cases = [SELECT Priority FROM Case];
        System.assertEquals('High', cases[0].Priority);
    }

    @isTest static void testSecondaryContact() {
        List<Contact> testContacts = TestContactController.createContacts(2, 2);
        Contact testContact = testContacts[0];

        Test.startTest();
        Database.SaveResult result = Database.insert(testContact);
        Test.stopTest();

        List<Case> cases = [SELECT Priority FROM Case];
        System.assertEquals('Medium', cases[0].Priority);
    }

    @isTest static void testTertiaryContact() {
        List<Contact> testContacts = TestContactController.createContacts(3, 3);
        Contact testContact = testContacts[0];

        Test.startTest();
        Database.SaveResult result = Database.insert(testContact);
        Test.stopTest();

        List<Case> cases = [SELECT Priority FROM Case];
        System.assertEquals('Low', cases[0].Priority);
    }
}
