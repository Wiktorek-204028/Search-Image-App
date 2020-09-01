@isTest
public without sharing class ImageQueryServiceTest {
    @TestSetup
    static void makeData(){
        List<Image> sampleData = new List<Image>();
        for(Integer i=0; i<150; i++){
            Image singleImage = new Image();
            singleImage.Title = 'testTitle'+i;
            singleImage.Url = '	https://via.placeholder.com/150/3147bf';
            singleImage.ImageExternalId__c = String.valueOf(i);
            sampleData.add(singleImage);
        }
        insert sampleData;
    }
    /**
     * Test checks if all records were found by ImageQueryService.getAllImages()
     * @return   List<Image>
     */ 
    @IsTest
    static void getAllImagesTest(){
        
        Test.startTest();
        List<Image> result = ImageQueryService.getAllImages();
        Test.stopTest();
        System.assertEquals(150, result.size());
    }
}