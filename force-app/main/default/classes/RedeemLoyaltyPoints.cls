public with sharing class RedeemLoyaltyPoints {

    public class Request {
        @InvocableVariable(label='Contact Id' description='Id of the verified contact.' required=true)
        public Id contactId;
        @InvocableVariable(label='Points To Redeem' description='Number of points the customer wants to redeem.' required=true)
        public Integer pointsToRedeem;
    }

    public class Response {
        @InvocableVariable(label='Discount Code' description='Discount code the customer received.')
        public String discountCode;
        @InvocableVariable(label='Remaining Points' description='Number of points left after the redemption.')
        public Integer remainingPoints;
    }

    @InvocableMethod(label='Redeem Loyalty Points' description='Redeems loyalty points of a verified customer for a discount code.')
    public static List<Response> run(List<Request> requests) {
        List<Response> responses = new List<Response>();
        for (Request request : requests) {
            Response response = new Response();
            Contact customer = [SELECT Id, Loyalty_Points__c FROM Contact WHERE Id = :request.contactId LIMIT 1];
            Integer balance = customer.Loyalty_Points__c == null ? 0 : Integer.valueOf(customer.Loyalty_Points__c);
            if (request.pointsToRedeem == null || request.pointsToRedeem <= 0 || request.pointsToRedeem > balance) {
                // Never redeem more than the customer has.
                response.remainingPoints = balance;
            } else {
                customer.Loyalty_Points__c = balance - request.pointsToRedeem;
                update customer;
                response.discountCode = 'LOYAL-' + String.valueOf(Crypto.getRandomInteger()).right(6);
                response.remainingPoints = balance - request.pointsToRedeem;
            }
            responses.add(response);
        }
        return responses;
    }
}
