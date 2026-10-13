public with sharing class CheckReturnEligibility {

    public class Request {
        @InvocableVariable(label='Order Number' description='Number of the order the customer wants to return.' required=true)
        public String orderNumber;
    }

    public class Response {
        @InvocableVariable(label='Eligible' description='True when the order can still be returned.')
        public Boolean eligible;
        @InvocableVariable(label='Reason' description='Why the order can or cannot be returned.')
        public String reason;
    }

    // A return is accepted for 30 days after the delivery date.
    private static final Integer RETURN_WINDOW_DAYS = 30;

    @InvocableMethod(label='Check Return Eligibility' description='Checks whether a delivered order can still be returned.')
    public static List<Response> run(List<Request> requests) {
        List<Response> responses = new List<Response>();
        for (Request request : requests) {
            Response response = new Response();
            List<Order> orders = [SELECT Id, Status, EndDate FROM Order WHERE OrderNumber = :request.orderNumber LIMIT 1];
            if (orders.isEmpty()) {
                response.eligible = false;
                response.reason = 'No order was found for this order number.';
            } else if (orders[0].EndDate == null || orders[0].EndDate.daysBetween(Date.today()) > RETURN_WINDOW_DAYS) {
                response.eligible = false;
                response.reason = 'The return window of ' + RETURN_WINDOW_DAYS + ' days after delivery has passed.';
            } else {
                response.eligible = true;
                response.reason = 'The order is inside the return window.';
            }
            responses.add(response);
        }
        return responses;
    }
}
