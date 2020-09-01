({
    doInitHelper : function(component, event) {
        var action = component.get("c.getImages");

        action.setCallback(this, function (response) {
            let values = response.getReturnValue();    
            component.set("v.images", values);
            component.set("v.imagesConstant", values);
            if(values.length==0){
                this.showToast('warning','No images found', 'Upload images firstly');
            }
        });
        $A.enqueueAction(action);      
    },
    searchHelper : function(component,event){
        var searchKey = component.find("searchKey").get("v.value").toLowerCase();
        var allImages = component.get('v.imagesConstant');
        var matchedImages = [];
        for (var i = 0; i < allImages.length; i++) {
            var currentName = allImages[i].Title.toLowerCase();
            if(currentName.startsWith(searchKey)){
                matchedImages.push(allImages[i]);
            }
        }
        if(matchedImages.length>0){
            component.set('v.images', matchedImages);
            component.set('v.selectedImages', matchedImages);
        }
        else{
            this.showToast('warning','No images found', 'Type other title');
        }
    },
    sendImagesHelper:function(component,event){
        var action = component.get("c.sendEmailWithImages");
        action.setParams({
            "selectedImages": component.get('v.selectedImages'),
            "emailAddress": component.get('v.emailAddress')             
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {     
                this.showToast('Success', 'Success!','Email with images has been sent!');
            } else{    
                let errors = response.getError();
                this.showToast('error', 'Can not send email', errors[0].message);
            }
        });
        $A.enqueueAction(action); 
    },
    showToast : function(type, title, message){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : type,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    },
    validateEmail : function(email){
        var re = /\S+@\S+\.\S+/;
        return re.test(email);
    }
})