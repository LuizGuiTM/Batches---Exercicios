@isTest
global class IntegracaoHTTPMock implements HttpCalloutMock {
    public IntegracaoHTTPMock() {}
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"ErrorMessage": "","Data": "Valid"}');
        response.setStatusCode(200);
        return response; 
    }

    @isTest 
    static void testPostCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IntegracaoHTTPMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse response = IntegracaoCPF.makePostCallout('122122122');
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = response.getBody();
        System.debug(response.getBody());
        String expectedValue = '{"ErrorMessage": "","Data": "Valid"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, response.getStatusCode());
    }

}