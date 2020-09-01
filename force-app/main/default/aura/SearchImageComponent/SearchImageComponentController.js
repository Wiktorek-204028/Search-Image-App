({
    doInit: function(component, event, helper) {
        helper.doInitHelper(component, event);
    },
    sendImages:function(component, event, helper){
      
      let email = component.get('v.emailAddress');
      if($A.util.isEmpty(email) || helper.validateEmail(email) === false){
        helper.showToast('error', 'Invalid email','Invalid format of email or empty!');
      }
      else{
        helper.sendImagesHelper(component, event);
      }

    },
    search : function(component,event, helper){
        helper.searchHelper(component,event);
    },
    showAll:function(component){
        component.set('v.images', component.get('v.imagesConstant'));
        component.set('v.selectedImages', null);
    },
    
})