public with sharing class ImagesMock implements HttpCalloutMock{
    /**
     * Method used to set Mock response for image callout
     * @param  HTTPRequest req 
     * @return HTTPResponse res
     */ 
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('['+
            '{'+
              '"albumId": 1,'+
              '"id": 1,'+
              '"title": "accusamus beatae ad facilis cum similique qui sunt",'+
              '"url": "https://via.placeholder.com/600/92c952",'+
              '"thumbnailUrl": "https://via.placeholder.com/150/92c952"'+
              '},'+
            '{'+
              '"albumId": 1,'+
              '"id": 2,'+
              '"title": "reprehenderit est deserunt velit ipsam",'+
              '"url": "https://via.placeholder.com/600/771796",'+
              '"thumbnailUrl": "https://via.placeholder.com/150/771796"'+
            '}]');
     
        res.setStatusCode(200);
        return res;
    }
}