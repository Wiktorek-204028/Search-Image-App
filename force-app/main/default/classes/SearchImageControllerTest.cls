@isTest
public with sharing class SearchImageControllerTest {
    /**
     * Test checks if SearchImageController.getImages() returns all records
     */
    @IsTest
    static void getImagesTest(){
        
        List<Image> sampleData = new List<Image>();
        for(Integer i=0; i<150; i++){
            Image singleImage = new Image();
            singleImage.Title = 'testTitle'+i;
            singleImage.Url = 'https://via.placeholder.com/150/3147bf';
            singleImage.ImageExternalId__c = String.valueOf(i);
            sampleData.add(singleImage);
        }
        insert sampleData;
        
        Test.startTest();
        List<Image> result = SearchImageController.getImages();
        Test.stopTest();
        
        System.assertEquals(150, result.size());
    }
    /**
     * Test checks if SearchImageController.sendEmailWithImages() sends email message
     */
    @IsTest
    static void sendEmailWithImagesTest(){
        List<Image> sampleData = new List<Image>();
        for(Integer i=0; i<2; i++){
            Image singleImage = new Image();
            singleImage.Title = 'testTitle'+i;
            singleImage.Url = 'https://via.placeholder.com/150/3147bf';
            singleImage.ImageExternalId__c = String.valueOf(i);
            sampleData.add(singleImage);
        }
        insert sampleData;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ContentMock());
        SearchImageController.sendEmailWithImages(sampleData, 'test@email.com');
        Test.stopTest();      
    }
        /**
     * Test checks if SearchImageController.sendEmailWithImages() handles exception properly
     */
    @IsTest
    static void sendEmailWithImagesCatchTest(){
        List<Image> sampleData = new List<Image>();
        for(Integer i=0; i<2; i++){
            Image singleImage = new Image();
            singleImage.Title = 'testTitle'+i;
            singleImage.Url = 'https://via.placeholder.com/150/3147bf';
            singleImage.ImageExternalId__c = String.valueOf(i);
            sampleData.add(singleImage);
        }
        insert sampleData;
        Boolean exceptionThrown = false;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ContentMock());
        try{
            SearchImageController.sendEmailWithImages(sampleData, 'testemail.com');
        }
        catch(Exception ex){
            exceptionThrown = true;
        }
        Test.stopTest(); 
        System.assertEquals(true, exceptionThrown);     
    }
    /**
     * Test checks if SearchImageController.getContent() returns blob based on image url
     */
    @IsTest
    static void getContentTest(){
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ContentMock());
        Blob result = SearchImageController.getContent('https://via.placeholder.com/150/3147bf');
        Test.stopTest();

        System.assertEquals(Blob.valueOf('testBlob'), result);
    }
}