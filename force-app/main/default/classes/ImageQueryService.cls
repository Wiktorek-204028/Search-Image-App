/**
 * SOQL service class contains all queries related to Image object.
 */ 
public with sharing class ImageQueryService {
    /**
     * Method return all records from Image object
     * @return   List<Image>
     */ 
    public static List<Image> getAllImages(){
        return [SELECT Id, Name, Title, Url, ImageExternalId__c, AlternateText, IsActive, CapturedAngle, ImageClass,
                        ContentDocumentId, ImageViewType, ImageClassObjectType 
                FROM Image];
    }
}