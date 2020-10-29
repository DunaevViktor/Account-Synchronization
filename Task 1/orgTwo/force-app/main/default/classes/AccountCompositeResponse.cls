public with sharing class AccountCompositeResponse {
    public String id;
    
    public static List<AccountCompositeResponse> parse(String json) {
        return (List<AccountCompositeResponse>) System.JSON.deserialize(json, List<AccountCompositeResponse>.class);
    }
}