public with sharing class ContentMock implements HttpCalloutMock{
    /**
     * Method used to set Mock response for image content callout
     * @param  HTTPRequest req 
     * @return HTTPResponse res
     */
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('testBlob');
        res.setStatusCode(200);
        return res;
    }
}