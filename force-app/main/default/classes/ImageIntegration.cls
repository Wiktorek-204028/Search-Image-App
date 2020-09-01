/**
 * This Queueable class needs to be scheduled and it is responsible for synchronizing 
 * images with Salesforce
 */ 
public without sharing class ImageIntegration implements Queueable, Database.AllowsCallouts{
    /**
     * Method used to synchronize images with Salesforce
     * @param  QueueableContext context
     */ 
    public void execute(QueueableContext context){
        List<Object> externalImages = sendRequest();
        Map<String, Image> salesforceImages = createCurrentImagesMap();
        refreshImages(externalImages, salesforceImages);
    }
    /**
     * Method retrieves and returns images from endpoint
     * @return   List<Object> 
     */ 
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
    /**
     * Method creates Map<String, Image> which stores Image records from Salesforce
     * @return   Map<String,Image>
     */ 
    @testVisible
    private static Map<String,Image> createCurrentImagesMap(){
        Map<String, Image> currentImages = new Map<String, Image>(); 
        for(Image singeImage : ImageQueryService.getAllImages()){
            currentImages.put(singeImage.ImageExternalId__c, singeImage );
        }
        return currentImages;
    }
    /**
     * Method synchronize data with external endpoint
     * @param   List<Object> externalImages
     * @param   Map<String, Image> salesforceImages
     */ 
    @testVisible
    private static void refreshImages(List<Object> externalImages, Map<String, Image> salesforceImages ){
        Set<String> externalIds = new Set<String>();
        List<Image> imagesToInsert = new List<Image>();
        for(Object singleImage : externalImages){      
            Map<String,Object> tmp = (Map<String,Object>) singleImage;
            String externalId = String.valueOf(tmp.get('id'));
            externalIds.add(externalId);
            if(salesforceImages.containsKey(externalId) == false ){
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
        deleteRedundantImages(externalIds, salesforceImages);
    }
    /**
     * Method deletes images if they don't exist in external endpoint
     * @param  Set<String>   externalIds 
     * @param  Map<String, Image>  salesforceImages 
     */
    @testVisible
    private static void deleteRedundantImages(Set<String> externalIds,  Map<String, Image> salesforceImages){
        List<Image> imagesToDelete = new List<Image>();
        for (Image singleImage: salesforceImages.values()) {
            
            if(externalIds.contains(singleImage.ImageExternalId__c) == false){
                imagesToDelete.add(singleImage);
            }
        }
        if(imagesToDelete.size()>0){
            delete imagesToDelete;
        }
    }
}