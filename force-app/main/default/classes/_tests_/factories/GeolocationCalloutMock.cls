public with sharing class GeolocationCalloutMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status":"success","results":[{"location":{"lat":49.2328817,"lng":28.47189773}}]}');
        res.setStatusCode(200);
        return res;
    }
}
