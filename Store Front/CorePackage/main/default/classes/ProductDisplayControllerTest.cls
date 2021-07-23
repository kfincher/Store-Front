@isTest
public class ProductDisplayControllerTest {
    @testSetup
    static void Setup(){
        List<String> itemNames = new List<String>{'Bagels','Bread','Sprite','Coke'};
            List<Item__c> itemList = new List<Item__c>();
        for(String itemName : itemNames){
            itemList.add(new Item__c(Name=itemName, Item_Type__c='Dairy',IsActive__c=true,Price__c=3.99, Quantity__c=10)); 
        }
        insert itemList;
    }
    @isTest 
    static void Main(){
        User me = [SELECT Name, FirstName From User Where FirstName='User'];
        
        System.runAs(me){
            List<Item__c> All = ProductDisplayController.search('All','Ba');
            List<Item__c> Dairy = ProductDisplayController.search('Dairy','Ba');
            List<Item__c> All2 = ProductDisplayController.search('All','null');
            List<Item__c> Dairy2 = ProductDisplayController.search('Dairy','null');
            
            System.assertEquals(4, Dairy2.size());
            System.assertEquals(1, Dairy.size());
            System.assertEquals(4, All2.size());
            System.assertEquals(1, All.size());
            
            Item__c item = [SELECT Id FROM Item__c LIMIT 1];
            Item__c item2 = ProductDisplayController.returnItem(item.Id);
            
            for(Integer i = 0;i<5;i++){
                ProductDisplayController.addItemToCart(item2.Id);
            }
            
            List<Cart_Item__c> CI = ProductDisplayController.returnCart();
            
            System.assertEquals(5,CI.size());
            
            ProductDisplayController.removeSingleItem(item2.id);
            
            CI = ProductDisplayController.returnCart();
            
            System.assertEquals(4,CI.size());
            
            ProductDisplayController.removeItemsFromCart(item2.id);
            
            CI = ProductDisplayController.returnCart();
            
            System.assertEquals(0,CI.size());
            
            for(Integer i = 0;i<5;i++){
                ProductDisplayController.addItemToCart(item2.Id);
            }
            
            Purchase__c testProduct = new Purchase__c(Address__c='221B Baker Street',	Credit_Card__c='1111111111111111',Zip_Code__c='12345',City__c='Westerpoint');
            
            insert testProduct;
            Test.startTest();
            
            ProductDisplayController.cartCheck();
            
            for(Integer i = 0;i<11;i++){
                ProductDisplayController.addItemToCart(item2.Id);
            }
            
            Cart__c cart = ProductDisplayController.returnCartTop();
            
            testProduct = new Purchase__c(Address__c='221B Baker Street',	Credit_Card__c='1111111111111111',Zip_Code__c='12345',City__c='Westerpoint');
            
            
            try{
                insert testProduct;
            }catch(Exception e){
                System.debug(e);
            }
            
            Test.stopTest();            
            List<ProductDisplayController.PurchaseWrapper> purWrap = ProductDisplayController.PreviousPurchases();
            
        }
    }
}