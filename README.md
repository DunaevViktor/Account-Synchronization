### Task 1:

It is necessary to implement synchronization of Accounts between two SF orgs.

1. It is carried out only when changing the fields: Name, Number, Phone, Billing Address, Shipping Address.
2. Synchronization should be as close to real time as possible.
3. Synchronization must be done in both directions.
4. Unit-test (coverage: 100%).

### Task 2:

1. Create custom field on Account object with type checkbox.
2. Detect changing this field, and if it is set to TRUE, need to generate a PDF file with Account information.
3. PDF file must be related to the account.
4. PDF should include:
    * Account info: Name, Phone, Billing and Shipping Addresses.
    * List of related Contacts: First Name, Last Name, Email, Phone and Address.
5. Create the button, which will work with logic of generating PDF.
6. Use LWC.
