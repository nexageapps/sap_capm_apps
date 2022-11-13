namespace my.bookshop;
using { Country, managed } from '@sap/cds/common';

entity Books {
  key ID : UUID                   @title : 'ID';   
  title  : localized String       @title : 'Title'; 
  author : Association to Authors @title : 'Author Name';
  stock  : Integer                @title : 'Stock proce';
  price  : Integer                @title : 'Price';
  currency_code : String          @title : 'Currency';
}

entity Authors {
  key ID : UUID                   @title : 'Authod ID';
  name   : String                 @title:  'Author Name';
  books  : Association to many Books on books.author = $self;
  age    : Integer                @title : 'Age';
  activeyear : String             @title : 'Active year';
  alive : String(1);
}

entity Orders {
  key ID  : UUID                  @title : 'ID';
  book    : Association to Books  @title : 'Book';
  qty     : Integer               @title : 'Quantity';
  amount  : Integer               @title : 'Amount';
}
