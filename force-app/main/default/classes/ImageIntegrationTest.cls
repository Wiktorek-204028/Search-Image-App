@isTest
public without sharing class ImageIntegrationTest {
    /**
     * Test checks if ImageIntegration.execute() works properly. 
     */ 
    @IsTest
    static void executeTest(){
        List<Image> sampleData = new List<Image>();
        for(Integer i=0; i<4; i++){
            Image singleImage = new Image();
            singleImage.Title = 'testTitle'+i;
            singleImage.Url = 'https://via.placeholder.com/150/3147bf';
            singleImage.ImageExternalId__c = String.valueOf(i);
            sampleData.add(singleImage);
        }
        insert sampleData;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ImagesMock());
        System.enqueueJob(new ImageIntegration());
        Test.stopTest();

        List<Image> result = [SELECT Id, ImageExternalId__c FROM Image];
        System.assertEquals(2, result.size());
    }
    /**
     * Test checks if ImageIntegration.sendRequest() returns values properly
     */
    @IsTest
    static void sendRequestTest(){
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ImagesMock());
        List<Object> results = ImageIntegration.sendRequest();
        Test.stopTest();
        
        System.assertEquals(2, results.size());
    }
    /**
     * Test checks if ImageIntegration.createCurrentImagesMap() returns proper map.
     */ 
    @IsTest
    static void createCurrentImagesMapTest(){

        List<Image> sampleData = new List<Image>();
        for(Integer i=0; i<4; i++){
            Image singleImage = new Image();
            singleImage.Title = 'testTitle'+i;
            singleImage.Url = 'https://via.placeholder.com/150/3147bf';
            singleImage.ImageExternalId__c = String.valueOf(i);
            sampleData.add(singleImage);
        }
        insert sampleData;
        
        Test.startTest();
        Map<String,Image> result = ImageIntegration.createCurrentImagesMap();
        Test.stopTest();

        System.assertEquals(4, result.size());
        System.assertEquals('testTitle3', result.get('3').Title);
    }
    /**
     * Test checks if ImageIntegration.refreshImages() synchonize images properly.
     */ 
    @IsTest
    static void refreshImagesTest(){
        String jsonData = '['+
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
        '}]';

        Map<String,Image> sampleData = new Map<String,Image>();
        for(Integer i=2; i<6; i++){
            Image singleImage = new Image();
            singleImage.Title = 'testTitle'+i;
            singleImage.Url = 'https://via.placeholder.com/150/3147bf';
            singleImage.ImageExternalId__c = String.valueOf(i);
            sampleData.put(singleImage.ImageExternalId__c, singleImage);
        }
        insert sampleData.values();

        List<Object> imageList = (List<Object>) JSON.deserializeUntyped(jsonData);

        Test.startTest();
        ImageIntegration.refreshImages(imageList, sampleData);
        Test.stopTest();

        List<Image> result = [SELECT Id, ImageExternalId__c FROM Image];
        System.assertEquals(2, result.size());
    }
    /**
     * Test checks if ImageIntegration.refreshImages() synchonize images properly when Salesforce database is empty
     */ 
    @IsTest
    static void refreshImagesNoDataTest(){
        String jsonData = '['+
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
        '}]';

        Map<String,Image> sampleData = new Map<String,Image>();
        List<Object> imageList = (List<Object>) JSON.deserializeUntyped(jsonData);

        Test.startTest();
        ImageIntegration.refreshImages(imageList, sampleData);
        Test.stopTest();

        List<Image> result = [SELECT Id, ImageExternalId__c FROM Image];
        System.assertEquals(2, result.size());
    }
    /**
     * Test checks if ImageIntegration.deleteRedundantImages() deletes proper records.
     */ 
    @IsTest
    static void deleteRedundantImagesTest(){

        Map<String,Image> sampleData = new Map<String,Image>();
        for(Integer i=0; i<4; i++){
            Image singleImage = new Image();
            singleImage.Title = 'testTitle'+i;
            singleImage.Url = 'https://via.placeholder.com/150/3147bf';
            singleImage.ImageExternalId__c = String.valueOf(i);
            sampleData.put(singleImage.ImageExternalId__c, singleImage);
        }
        insert sampleData.values();

        Set<String> externalIds = new Set<String>{'5','6','7','1','2'};
        
        Test.startTest();
        ImageIntegration.deleteRedundantImages(externalIds, sampleData);
        Test.stopTest();
        List<Image> result = [SELECT Id, ImageExternalId__c FROM Image];
        System.assertEquals(2, result.size());
    }
}