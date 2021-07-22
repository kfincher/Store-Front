trigger PurchaseTrigger on Purchase__c (before insert, after insert) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            //PurchaseTriggerHelper.UpdateDate(trigger.new);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            PurchaseTriggerHelper.AdvancedValidity(trigger.new);
            PurchaseTriggerHelper.TransferToPurchase(trigger.new);
        }
    }
}