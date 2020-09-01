public without sharing class SearchImageController {
    /**
     * Method return all records from Image object
    * @return   List<Image>
    */ 
    @AuraEnabled
    public static List<Image> getImages(){
        return ImageQueryService.getAllImages();
    }
    /**
     * Method responsible for sending email with filtred by user images
     * @param  List<Image> selectedImages 
     * @param  String  emailAddress 
     */ 
    @AuraEnabled
    public static void sendEmailWithImages(List<Image> selectedImages, String emailAddress){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

        message.setToAddresses(new String[] { emailAddress });
        message.setSubject('Enjoy your images!');
        message.setPlainTextBody('I hope my solution meets your requirements!');

        List<Messaging.EmailFileAttachment> attachmentList = new List<Messaging.EmailFileAttachment>();
        for (Image singleImage: selectedImages) {
            Messaging.EmailFileAttachment singleAttachment = new Messaging.EmailFileAttachment();
            singleAttachment.setFileName(singleImage.Title);
            Blob body = getContent(singleImage.Url);
            singleAttachment.setBody(body);
            singleAttachment.setContentType('image/png');
            attachmentList.add(singleAttachment);
        }
        message.setFileAttachments(attachmentList);
       try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });
       } 
        catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());        }
    }
    /**
     * Method returns Blob from image url
     * @param  String url
     * @return Blob 
     */ 
    @testVisible
    private static Blob getContent(String url){
        HttpRequest requestObj = new HttpRequest();
        requestObj.setMethod('GET');
        requestObj.setEndpoint(url);
        Http httpObj = new Http();
        HttpResponse responseObj = httpObj.send(requestObj );
        Blob blobContent = responseObj.getbodyasblob(); 
        return blobContent;
    }
}