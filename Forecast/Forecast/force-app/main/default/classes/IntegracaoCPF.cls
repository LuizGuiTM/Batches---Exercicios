public with sharing class IntegracaoCPF {
    public IntegracaoCPF() {}

    /*public static HttpResponse makeGetCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'animals' key as a list
            List<Object> animals = (List<Object>) results.get('animals');
            System.debug('Received the following animals:');
            for(Object animal: animals) {
                System.debug(animal);
            }
        }
        return response;  
    } */
    
    public static HttpResponse makePostCallout(String CPF) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://functiaria20220217105539.azurewebsites.net/api/ValidarCPF?code=xH0faw4w1nkQ0HYmbrGbm8rMjIf269H6GamVVxEL5YYSfKZBeLRGPg==');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody('{ "doctype": "CPF","docNumber": "'+CPF+'"}');
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if(response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('Resposta da API' + response.getBody());
        }
        return response;
    }        
}