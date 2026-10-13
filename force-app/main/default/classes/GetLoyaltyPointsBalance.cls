public with sharing class GetLoyaltyPointsBalance {

    public class Request {
        @InvocableVariable(label='Contact Id' description='Id of the verified contact.' required=true)
        public Id contactId;
    }

    public class Response {
        @InvocableVariable(label='Points Balance' description='Number of loyalty points the customer has.')
        public Integer pointsBalance;
    }

    @InvocableMethod(label='Get Loyalty Points Balance' description='Returns the loyalty points balance of a verified customer.')
    public static List<Response> run(List<Request> requests) {
        List<Response> responses = new List<Response>();
        for (Request request : requests) {
            Response response = new Response();
            List<Contact> contacts = [SELECT Id, Loyalty_Points__c FROM Contact WHERE Id = :request.contactId LIMIT 1];
            response.pointsBalance = contacts.isEmpty() || contacts[0].Loyalty_Points__c == null ? 0 : Integer.valueOf(contacts[0].Loyalty_Points__c);
            responses.add(response);
        }
        return responses;
    }
}
