global class ProductDisplayController {
    @AuraEnabled
    public static List<Item__c> search(String filter, String search){
        List<Item__c> pro = new List<Item__c>();
        search = '%'+search+'%';
        System.debug(search);
        if(search=='%null%'){
            switch on filter{
                when 'All' {
                    pro = [SELECT Id, Price__c, Name, DisplayURL__c, IsActive__c FROM Item__c WHERE IsActive__c=true];
                }
                when else{
                    pro = [SELECT Id, Price__c, Name, DisplayURL__c, IsActive__c, Item_Type__c FROM Item__c WHERE IsActive__c=true AND Item_Type__c includes (:filter)];
                }
            }
        }else{
            switch on filter{
                when 'All' {
                    pro = [SELECT Id, Price__c, Name, DisplayURL__c, IsActive__c FROM Item__c WHERE IsActive__c=true AND Name LIKE :search];
                }
                when else{
                    pro = [SELECT Id, Price__c, Name, DisplayURL__c, IsActive__c, Item_Type__c FROM Item__c WHERE IsActive__c=true AND Name LIKE :search AND Item_Type__c includes (:filter)];
                }
            }
        }
        return pro;
    }
    @AuraEnabled
    public static void addItemToCart(Id item){
        Item__c itemName = [SELECT Id, Name FROM Item__c WHERE id=:item];
        List<Cart__c> cart = [SELECT Id, UserID__c FROM Cart__c WHERE UserID__c = :UserInfo.getUserId() AND IsActive__c = true LIMIT 1];
        if(cart.size()==0){
            ContactCart.createCart(UserInfo.getUserId());
            cart = [SELECT Id, UserID__c FROM Cart__c WHERE UserID__c = :UserInfo.getUserId() AND IsActive__c = true LIMIT 1];
        }
        Cart_Item__c CI = new Cart_Item__c(Item__c = itemName.id, Cart__c=cart[0].id);
        insert CI;
    }
    @AuraEnabled
    public static void removeSingleItem(Id item){
        //Item__c itemName = [SELECT Id, Name FROM Item__c WHERE id=:item];
        Cart__c cart = [SELECT Id, UserID__c FROM Cart__c WHERE UserID__c = :UserInfo.getUserId() AND IsActive__c = true];
        if(cart!=null){
            Cart_Item__c CI = [SELECT Item__r.Name, Cart__r.id, Item__r.id FROM Cart_Item__c WHERE Cart__r.id=:cart.id AND Item__r.id=:item LIMIT 1];
            System.debug('Debugging: ');
            System.debug(CI);
            delete CI;
        }
    }
    @AuraEnabled
    public static void removeItemsFromCart(Id item){
        Item__c itemName = [SELECT Id, Name FROM Item__c WHERE id=:item];
        Cart__c cart = [SELECT Id, UserID__c FROM Cart__c WHERE UserID__c = :UserInfo.getUserId() AND IsActive__c = true];
        List<Cart_item__c> itemToRemove = [SELECT Item__c, Cart__c FROM Cart_Item__c Where Item__c = :itemName.Id AND Cart__c = :cart.Id];
        delete itemToRemove;
    }
    @AuraEnabled
    public static List<Cart_Item__c> returnCart(){
        Id userID = UserInfo.getUserId();
        cartCheck();
        return [SELECT Item__r.Name, Item__r.Price__c, 	Cart__r.Subtotal__c, Cart__r.UserID__c FROM Cart_Item__c WHERE Cart__r.UserID__c = :userID AND Cart__r.IsActive__c = true ORDER BY Item__r.Name];
    }
    public static void cartCheck(){
        List<Cart__c> cart = [SELECT Id, UserID__c FROM Cart__c WHERE UserID__c = :UserInfo.getUserId() AND IsActive__c = true LIMIT 1];
        if(cart.size()==0)
            ContactCart.createCart(UserInfo.getUserId());
    }
    @AuraEnabled
    public static Cart__c returnCartTop(){
        Id userID = UserInfo.getUserId();
        return [SELECT Total__c, Subtotal__c, UserID__c FROM Cart__c WHERE UserID__c = :userID AND IsActive__c=true];
    }
    @AuraEnabled
    public static Item__c returnItem(Id item){
        return [SELECT Name, Price__c, DisplayURL__C, Item_Type__c, Description__c FROM Item__c WHERE ID = :item];
    }
    
    @AuraEnabled
    public static List<PurchaseWrapper> PreviousPurchases(){
        List<PurchaseWrapper> purWrap = new List<PurchaseWrapper>();
        
        for(Purchase__c pur :[SELECT Name, Date_Completed__c, (SELECT Subtotal__c, Total__c, Name FROM Carts__r) FROM Purchase__c ORDER BY Date_Completed__c DESC]){
            
            if(pur.Carts__r.size()>0){
                Map<Id, CartItemWrapper> Items = new Map<Id, CartItemWrapper>();
                
                for(Cart_Item__C CI : [SELECT Item__r.Name, Item__r.id , Price__c FROM Cart_Item__c WHERE Cart__r.id = :pur.Carts__r[0].id]){
                    if(Items.containsKey(CI.Item__r.id)){
                        CartItemWrapper CIW = Items.get(CI.Item__r.id);
                        CIW.Amount += 1;
                        Items.put(CI.Item__r.id,CIW);
                    }else{
                        CartItemWrapper CIW = new CartItemWrapper(CI, 1);
                        Items.put(CI.Item__r.id,CIW);
                    }
                    
                }
                
                PurchaseWrapper temp = new PurchaseWrapper(pur,pur.Carts__r[0], Items.values());
                purWrap.add(temp);
            }
            
        }
        return purWrap;
    }
    public class CartItemWrapper{
        @AuraEnabled public Cart_Item__c Item;
        @AuraEnabled public Integer Amount;
        
        CartItemWrapper(Cart_Item__c Item, Integer Amount){
            this.Item = Item;
            this.Amount = Amount;
        }
    }
    
    
    global class PurchaseWrapper{
        @AuraEnabled public Purchase__c Purchase;
        @AuraEnabled public Cart__c Cart;
        @AuraEnabled public List<CartItemWrapper> Items;
        
        PurchaseWrapper(Purchase__c Purchase, Cart__c Cart, List<CartItemWrapper> Items){
            this.Purchase = Purchase;
            this.Cart = Cart;
            this.Items = Items;
        }
    }
}