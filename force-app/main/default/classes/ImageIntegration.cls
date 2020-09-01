public without sharing class ImageIntegration implements Queueable, Database.AllowsCallouts{
    
    public void execute(QueueableContext context){
        List<Object> externalImages = sendRequest();
        Map<String, Image> salesforceImages = createCurrentImagesMap();
        refreshImages(externalImages, salesforceImages);
    }
    @testVisible
    private static List<Object> sendRequest(){
        String endpoint = 'https://jsonplaceholder.typicode.com/photos';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setTimeout(120000);
        req.setMethod('GET');

        Http http = new Http();
        HTTPResponse res = http.send(req);

        List<Object> results = (List<Object>) JSON.deserializeUntyped(res.getBody());
        return results;
    }
    @testVisible
    private static Map<String,Image> createCurrentImagesMap(){
        Map<String, Image> currentImages = new Map<String, Image>(); 
        for(Image singeImage : ImageQueryService.getAllImages()){
            currentImages.put(singeImage.ImageExternalId__c, singeImage );
        }
        return currentImages;
    }
    @testVisible
    private static void refreshImages(List<Object> externalImages, Map<String, Image> currentImages ){
        Set<String> externalIds = new Set<String>();
        List<Image> imagesToInsert = new List<Image>();
        for(Object singleImage : externalImages){      
            Map<String,Object> tmp = (Map<String,Object>) singleImage;
            String externalId = String.valueOf(tmp.get('id'));
            externalIds.add(externalId);
            if(currentImages.containsKey(externalId) == false ){
                Image image = new Image();
                image.Title = String.valueOf(tmp.get('title'));
                image.Url = String.valueOf(tmp.get('thumbnailUrl'));
                image.ImageExternalId__c = externalId;
                imagesToInsert.add(image);
            }
        }
        if(imagesToInsert.size()>0){
            insert imagesToInsert;
        }
        deleteRedundant(externalIds, currentImages);
    }
    @testVisible
    private static void deleteRedundant(Set<String> externalIds,  Map<String, Image> currentImages){
        List<Image> imagesToDelete = new List<Image>();
        for (Image singleImage: currentImages.values()) {
            
            if(externalIds.contains(singleImage.ImageExternalId__c) == false){
                imagesToDelete.add(singleImage);
            }
        }
        if(imagesToDelete.size()>0){
            delete imagesToDelete;
        }
    }
}