public with sharing class AccountCompositeRequest {

    Boolean allOrNone;
    List<Map<String, Object>> records;

    public AccountCompositeRequest(List<Account> accounts) {
        records = new List<Map<String,Object>>();

        for(Account account: accounts){
            Map<String, Object> recordFields = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(account));
            Map<String, String> attributes = new Map<String, String>();
            attributes.put('type', 'Account');
            recordFields.put('attributes', attributes);
            records.add(new Map<String, Object>(recordFields));
        }
        allOrNone = false;
    }
}
