/*
* Name: PurchaseTriggerHelper
* Author: Kameron Fincher
* Description: Meant to perform validation checks on purchases and transfer carts properly
*/
public class PurchaseTriggerHelper {
    /*public static void UpdateDate(List<Purchase__c> pur){
for(Purchase__c IndPur : pur){
IndPur.
}
}*/
    public static void TransferToPurchase(List<Purchase__c> pur){
        Cart__c cart = [SELECT Id, IsActive__c, UserID__c from Cart__c WHERE UserID__c = :UserInfo.getUserId() AND IsActive__c = true];    
        cart.Purchase__c = pur[0].id;
        cart.IsActive__c = false;
       
        update cart;
        
        ProductDisplayController.PurchaseWrapper PW = ProductDisplayController.PreviousPurchase(); 
        User thisUser = [SELECT Email FROM User WHERE ID = :UserInfo.getUserId()];
        sendEmailConfirmation(thisUser.email, PW);
        
    }
    
    public class ItemWrapper{
        Integer Amount;
        Integer Quantity;
        String Name;
        
        public ItemWrapper(Integer Amount, Decimal Quantity, String Name){
            this.Amount = Amount;
            this.Quantity = Integer.valueOf(Quantity);
            this.Name = Name;
        }
        
    }
    
    public static void AdvancedValidity(List<Purchase__c> pur){        
        Map<Id, ItemWrapper> CIMap = new Map<Id, ItemWrapper>(); 
        
        for(Cart_Item__c IndCI : [SELECT Item__r.Name, Item__r.Quantity__c, Cart__r.IsActive__c FROM Cart_Item__c WHERE Cart__r.IsActive__c = true]){
            Id temp = IndCI.Item__r.Id;
            ItemWrapper IW = CIMap.get(temp);
            
            if(IW!=null){
                IW.Amount+=1;
                CIMap.put(temp, IW);
            }else{
                CIMap.put(temp, new ItemWrapper(1, IndCI.Item__r.Quantity__c, IndCI.Item__r.Name));
            }
            
        }
        
        
        
        for(Id key : CIMap.keyset()){
            if(CIMap.get(key).Amount>CIMap.get(key).Quantity){
                System.debug(key + ' out of stock');
                sendEmail(CIMap.get(key).Name);
                pur[0].addError(CIMap.get(key).Name + ' out of stock');
            }  
        }
        
        List<Item__c> itemsToUpdate = [SELECT Name, Id, Quantity__c FROM Item__c Where ID in :CIMap.keyset()]; 
        for(item__c item : itemsToUpdate){
            item.Quantity__c -= CIMap.get(item.Id).Amount;
        }
        
        update itemsToUpdate;
    }
    public static void sendEmailConfirmation(String email, ProductDisplayController.PurchaseWrapper items){   
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //String toRecipients = 'storefrontsf@gmail.com';
        String[] toAddresses = new String[]{email };
            mail.setToAddresses(toAddresses);
        mail.setReplyTo('kameron.fincher@revature.net');
        mail.setSenderDisplayName('Kameron Fincher');
        mail.setSubject('Receipt for transaction');
        String bodyText = 'Your order is on the way!<br>'+purchaseParser(items);
        mail.setHtmlBody(bodyText);
        Messaging.SendEmailResult [] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
    public static String purchaseParser(ProductDisplayController.PurchaseWrapper items){
        String resultString = '';
        for(ProductDisplayController.CartItemWrapper CIW : items.Items){
            resultString+= '$'+(CIW.Amount*CIW.Item.Price__c)+' '+CIW.Item.Item__r.Name+' x'+CIW.Amount+'<br>';
        }
        resultString += +'Subtotal: $'+items.Cart.Subtotal__c+'<br>';
        resultString += +'Total: $'+items.Cart.Total__c+'<br>';
        return resultString;
    }
    public static void sendEmail(String name){   
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String toRecipients = 'storefrontsf@gmail.com';
        String[] toAddresses = new String[]{'storefrontsf@gmail.com' };
            mail.setToAddresses(toAddresses);
        mail.setReplyTo('kameron.fincher@revature.net');
        mail.setSenderDisplayName('Kameron Fincher');
        mail.setSubject('Item out of stock!');
        String bodyText = name+ ' is currently our of stock! Please place an order no this ASAP.';
        mail.setHtmlBody(bodyText);
        Messaging.SendEmailResult [] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
}