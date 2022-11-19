module.exports = (srv) => {

  const {Books} = cds.entities ('my.bookshop')

  // Reduce stock of ordered books
  srv.before ('CREATE', 'Orders', async (req) => {
    const order = req.data

    if (!order.qty || order.qty <= 0)  return req.error (400, 'Order at least 1 book')
    const tx = cds.transaction(req)
    const affectedRows = await tx.run (
      UPDATE (Books)
        .set   ({ stock: {'-=': order.qty}})
        .where ({ stock: {'>=': order.qty},/*and*/ ID: order.book_ID})
    )
    if (affectedRows === 0)  req.error (409, "Sold out, sorry")
  })

  // LifeHook: Concat two values after it has rendered 
  srv.after ('READ', 'Books', each => {

    //Book price with discount 
    const discount = (each.price >= 500) ? 10 : 0;
    if(discount>0){
      each.price_with_curr = each.price - (each.price / discount);
    }else{
      each.price_with_curr = each.price; 
    }
    each.price_with_curr += ' ' + each.currency_code + ' with ' + discount + '% discount';

    //Provide actions at stock criticality 
    //i.e If stock count less than 10 then mark critical else mark none 
    if(each.stock < 20){
      each.uiStockStatus = 2; //#Critical = 2
    }  

    
  })


  

}
