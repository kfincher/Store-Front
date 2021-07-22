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
                //sendEmail(CIMap.get(key).Name);
                //pur[0].addError(CIMap.get(key).Name + ' out of stock');
            }   
        }
        
        List<Item__c> itemsToUpdate = [SELECT Name, Id, Quantity__c FROM Item__c Where ID in :CIMap.keyset()]; 
        for(item__c item : itemsToUpdate){
            System.debug(CIMap.get(item.Id)+' '+item.Quantity__c);
            item.Quantity__c -= CIMap.get(item.Id).Amount;
        }
        
        update itemsToUpdate;
    }
    
    /*public static void sendEmail(String name){
                
        String sMessage='';
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String toRecipients = 'storefrontsf@gmail.com';
           // String[] toAddresses = toRecipients.split(';', 0);
           String[] toAddresses = new String[]{'storefrontsf@gmail.com' };
            mail.setToAddresses(toAddresses);
            mail.setSubject('Subject Test Message');
            mail.setHtmlBody('This is the message body.');
            Messaging.SendEmailResult [] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            sMessage='Success';
            System.debug(results);
        }
        catch(Exception ex){
            sMessage=ex.getLineNumber()+'\n'+ex.getCause()+'\n'+ex.getMessage()+'\n'+ex.getStackTraceString();
        }
        System.debug('Email message: '+sMessage);
    }*/
}