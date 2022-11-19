namespace my.bookshop;
annotate service.Books with {
    bookname @Common : {
        Text            : bookname.Title,
        TextArrangement : #TextOnly,
        ValueListWithFixedValues
    };
};
