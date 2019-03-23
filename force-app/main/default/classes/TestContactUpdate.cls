@isTest
public with sharing class TestContactUpdate {
    @isTest static void testContactUpdate() {
        List<Contact> testContacts = TestContactController.createContacts(2, 1);
        
        // Two accounts
        Account acct = new Account(Name='Test Account');
        Account newAcct = new Account(Name='New Account');
        List<Account> accs = new List<Account>();
        accs.add(acct);
        accs.add(newAcct);

        User owner = [SELECT Id FROM USER LIMIT 1];
        acct.OwnerId = owner.Id;
        newAcct.OwnerId = owner.Id;
        insert accs;
        for(Contact contact : testContacts) {
            contact.AccountId=acct.Id;
        }
        insert testContacts;
        Contact contact = [SELECT AccountId, Contact_Level__c FROM Contact LIMIT 1];
        contact.AccountId = newAcct.Id;
        contact.Contact_Level__c = 'Tertiary';
        
        Test.startTest();
        Database.SaveResult result = Database.update(contact);
        Test.stopTest();

        Case updatedCase = [SELECT OwnerId, Priority FROM Case WHERE ContactId=:contact.Id];

        // Updated case: Priority = 'Low', new associated Account
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
        System.assertEquals(newAcct.OwnerId, updatedCase.OwnerId);
        System.assertEquals('Low', updatedCase.Priority);
    }
}
