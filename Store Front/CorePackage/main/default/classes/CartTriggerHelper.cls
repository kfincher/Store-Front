public class CartTriggerHelper {
    public static void updateSubtotal(List<Cart_Item__c> cart){
        System.debug('Made it to A');
        Cart__c crt = [SELECT Id, UserID__c, IsActive__c FROM Cart__c WHERE UserID__c = :UserInfo.getUserId() AND IsActive__c = true];
        crt.Subtotal__c = 0.0;
        System.debug('Made it to B');
        for(Cart_Item__c CI : [SELECT Item__r.Price__c, Cart__r.Id From Cart_Item__c WHERE Cart__r.Id = :crt.id]){
            if(CI.Item__r.Price__c!=null)
            	crt.Subtotal__c += CI.Item__r.Price__c;
        }
        System.debug('Made it to C');
        crt.Total__c = (crt.Subtotal__c*1.0825).setScale(2);
        update crt;
    }
}