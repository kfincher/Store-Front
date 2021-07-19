@isTest
public class ProductDisplayControllerTest {
    @testSetup
    static void Setup(){
        List<String> itemNames = new List<String>{'Bagels','Bread','Sprite','Coke'};
            List<Item__c> itemList = new List<Item__c>();
        for(String itemName : itemNames){
            itemList.add(new Item__c(Name=itemName, Item_Type__c='Dairy',IsActive__c=true)); 
        }
        insert itemList;
    }
    @isTest
    static void Main(){
        User me = [SELECT Name, FirstName From User Where FirstName='User'];
        System.runAs(me){
            List<Item__c> All = ProductDisplayController.search('All');
            List<Item__c> Dairy = ProductDisplayController.search('Dairy');
            
            System.assertEquals(4, Dairy.size());
            System.assertEquals(4, All.size());
            
            Item__c item = [SELECT Id FROM Item__c LIMIT 1];
            Item__c item2 = ProductDisplayController.returnItem(item.Id);
            System.debug('A');
            for(Integer i = 0;i<5;i++){
                ProductDisplayController.addItemToCart(item2.Id);
            }
            System.debug('B');       
            List<Cart_Item__c> CI = ProductDisplayController.returnCart();
            System.debug('C');
            System.assertEquals(5,CI.size());
        }
    }
}