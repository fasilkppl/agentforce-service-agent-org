public with sharing class CreateReturnRequest {

    public class Request {
        @InvocableVariable(label='Order Number' description='Number of the order to return.' required=true)
        public String orderNumber;
        @InvocableVariable(label='Return Reason' description='Why the customer returns the order.' required=true)
        public String returnReason;
    }

    public class Response {
        @InvocableVariable(label='Return Request Number' description='Number of the return request that was created.')
        public String returnRequestNumber;
    }

    @InvocableMethod(label='Create Return Request' description='Creates a return request for an order that is eligible for return.')
    public static List<Response> run(List<Request> requests) {
        List<Response> responses = new List<Response>();
        for (Request request : requests) {
            List<Order> orders = [SELECT Id, AccountId FROM Order WHERE OrderNumber = :request.orderNumber LIMIT 1];
            Response response = new Response();
            if (!orders.isEmpty()) {
                Case returnCase = new Case(
                    Subject = 'Return request for order ' + request.orderNumber,
                    Description = request.returnReason,
                    AccountId = orders[0].AccountId,
                    Type = 'Return'
                );
                insert returnCase;
                response.returnRequestNumber = [SELECT CaseNumber FROM Case WHERE Id = :returnCase.Id].CaseNumber;
            }
            responses.add(response);
        }
        return responses;
    }
}
