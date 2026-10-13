public with sharing class IssueRefund {

    public class Request {
        @InvocableVariable(label='Return Request Number' description='Number of the approved return request.' required=true)
        public String returnRequestNumber;
    }

    public class Response {
        @InvocableVariable(label='Refund Amount' description='Amount that was refunded to the customer.')
        public Decimal refundAmount;
        @InvocableVariable(label='Refund Status' description='Status of the refund after the action ran.')
        public String refundStatus;
    }

    // A refund above this amount is escalated to a live agent.
    private static final Decimal ESCALATION_LIMIT_USD = 200;

    @InvocableMethod(label='Issue Refund' description='Issues a refund for an approved return request.')
    public static List<Response> run(List<Request> requests) {
        List<Response> responses = new List<Response>();
        for (Request request : requests) {
            Response response = new Response();
            List<Case> returns = [SELECT Id, Status, Order__r.TotalAmount FROM Case WHERE CaseNumber = :request.returnRequestNumber AND Type = 'Return' LIMIT 1];
            if (returns.isEmpty() || returns[0].Status != 'Approved') {
                response.refundAmount = 0;
                response.refundStatus = 'Not refunded: the return request is not approved.';
            } else if (returns[0].Order__r.TotalAmount > ESCALATION_LIMIT_USD) {
                // Larger refunds are decided by a person, never by the agent.
                response.refundAmount = 0;
                response.refundStatus = 'Needs a live agent: the amount is above ' + ESCALATION_LIMIT_USD + ' USD.';
            } else {
                response.refundAmount = returns[0].Order__r.TotalAmount;
                response.refundStatus = 'Refunded';
                returns[0].Status = 'Closed';
                update returns[0];
            }
            responses.add(response);
        }
        return responses;
    }
}
