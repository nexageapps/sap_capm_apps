namespace my.bookshop;
using { Country, managed } from '@sap/cds/common';

entity Books {
  key ID : Integer                @title : 'ID';
  title  : localized String       @title : 'Title'; 
  author : Association to Authors @title : 'Author Name';
  stock  : Integer                @title : 'Stock proce';
  price  : Integer                @title : 'Price';
  currency_code : String          @title : 'Currency';
}

entity Authors {
  key ID : Integer;
  name   : String                 @title: 'Author Name';
  books  : Association to many Books on books.author = $self;
}

entity Orders : managed {
  key ID  : UUID;
  book    : Association to Books;
  country : Country;
  amount  : Integer;
}
