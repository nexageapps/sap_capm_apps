module.exports = (srv) => {

  const {Books} = cds.entities ('my.bookshop')

  // Reduce stock of ordered books
  srv.before ('CREATE', 'Orders', async (req) => {
    const order = req.data
    if (!order.amount || order.amount <= 0)  return req.error (400, 'Order at least 1 book')
    const tx = cds.transaction(req)
    const affectedRows = await tx.run (
      UPDATE (Books)
        .set   ({ stock: {'-=': order.amount}})
        .where ({ stock: {'>=': order.amount},/*and*/ ID: order.book_ID})
    )
    if (affectedRows === 0)  req.error (409, "Sold out, sorry")
  })

  // LifeHook: Concat two values after it has rendered 
  srv.after ('READ', 'Books', each => {

    //Book price with discount 
    const discount = (each.price >= 100) ? 10 : 0;
    if(discount>0){
      each.price_with_curr = each.price - (each.price / discount);
    }else{
      each.price_with_curr = each.price; 
    }

    each.price_with_curr += ' ' + each.currency_code + ' with ' + discount + '% discount'
  })

}
