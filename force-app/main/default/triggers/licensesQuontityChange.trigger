trigger licensesQuontityChange on Instance__c (after insert, after update, after delete,after undelete, before insert,before update) {    
    if (Trigger.isAfter){
        instanceTriggerHelper.QuontityChange(Trigger.New);
    }
   
   if (Trigger.isBefore){
       instanceTriggerHelper.CheckContact(Trigger.New);
   }
}