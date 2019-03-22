@isTest
public with sharing class TestContactController {
    public static void createContacts(Integer amount) {

    List<Contact> contacts = new List<Contact>();
    String contactLevel = 'Primary';
    for (Integer i = 1; i <= amount; i++) {
        if (Math.mod(i, 2) == 0) {
            contactLevel = 'Secondary';
        } else if (Math.mod(i, 3) == 0) {
            contactLevel = 'Tertiary';
        }
        contacts.add(
            new Contact(
                FirstName='First' + i,
                LastName='Last' + i,
                Email='email' + i + '@test.com'
                )
            );
    }

    insert contacts;

    }
}
