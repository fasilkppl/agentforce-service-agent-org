public with sharing class GetDemoRichChoice {

    // Agentforce requires at least one input
    public class Request {
        @InvocableVariable(label='User Request'
            description='What the customer wants to choose from')
        public String userRequest;
    }

    // One option. The field names name/imageUrl/description are what make
    // Agentforce render the list as a rich choice (buttons/carousel/list).
    public class Choice {
        @InvocableVariable(label='name' description='Option label shown to the user')
        public String name;
        @InvocableVariable(label='imageUrl' description='URL of the option image')
        public String imageUrl;
        @InvocableVariable(label='description' description='Short description of the option')
        public String description;
    }

    public class Response {
        @InvocableVariable(label='choices'
            description='List of options to present as a rich choice')
        public List<Choice> choices;
    }

    @InvocableMethod(label='Get Demo Rich Choice'
        description='Returns a list of options to present to the customer as a rich choice (buttons/carousel/list).')
    public static List<Response> getChoices(List<Request> requests) {
        List<Choice> options = new List<Choice>();

        Choice c1 = new Choice();
        c1.name = 'Track an order';
        c1.description = 'Check the status of a recent order';
        c1.imageUrl = 'https://upload.wikimedia.org/wikipedia/commons/2/2f/Google_2015_logo.svg';
        options.add(c1);

        Choice c2 = new Choice();
        c2.name = 'Return an item';
        c2.description = 'Start a return or refund';
        options.add(c2);

        Choice c3 = new Choice();
        c3.name = 'Talk to a human';
        c3.description = 'Escalate to a live agent';
        options.add(c3);

        Response r = new Response();
        r.choices = options;
        return new List<Response>{ r };
    }
}