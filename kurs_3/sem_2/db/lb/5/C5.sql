select users.login,
      users.PASSWORD, 
        ROLES.description as role 
            from users
            join roles on users.roleid=roles.Id;

select users.login,
      users.PASSWORD, 
        ROLES.description as role 
            from users
            join roles on users.roleid=roles.Id
              where USERS.id = 1;

select users.login, 
      items.name as item_Name, 
      salesTable.SalesDate, 
      salesTable.SalesAmount, 
      salestable.itemprice from salesTable
  join users on users.id = salesTable.userId
  join items on items.id = salesTable.itemId;

select items.name as item_Name,
        items.type,
        items.notes,
        priceList.salesPrice as price,
        catalogofgoods.amount
        from catalogofgoods
        join pricelist on catalogofgoods.pricelistid=pricelist.ID
        join items on catalogofgoods.itemid=items.ID;
        
select items.name as item_Name,
        providers.name as provider,
        orders.qty,
        orders.OrderDate
        from orders
        join providers on orders.providerid=providers.ID
        join items on orders.itemid=items.ID;
        
select orders.id as order_id,
        items.name as item_Name,
        providers.name as provider,
        orders.OrderDate,
        invoices.INVOICEDATE,
        orders.qty,
        invoices.AMOUNTDELIVERY
        from invoices
        join orders on invoices.orderid=orders.ID
        join providers on orders.providerid=providers.ID
        join items on orders.itemid=items.ID;
      
      
select sites.id,
        orders.id as order_id,
        items.name as item_Name,
        providers.name as provider,
        orders.OrderDate,
        invoices.INVOICEDATE,
        orders.qty,
        invoices.AMOUNTDELIVERY,
        sites.amount as Amount_remaining
        from sites
        join invoices on sites.invoiceid=invoices.ID
        join orders on invoices.orderid=orders.ID
        join providers on orders.providerid=providers.ID
        join items on orders.itemid=items.ID;


        