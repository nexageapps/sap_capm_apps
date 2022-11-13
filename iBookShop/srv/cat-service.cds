using my.bookshop as my from '../db/data-model';

service CatalogService {
  entity Books @readonly as projection on my.Books;
  entity Authors @readonly as projection on my.Authors;
  entity Orders @insertonly as projection on my.Orders;
}
//Create UI to Book application - Read only
annotate CatalogService.Books with @(   
    UI: {
        HeaderInfo: {
            TypeName: 'Book',  
            TypeNamePlural: 'Books',
            Title: { Value: ID },
            Description: { Value: title }
        },
        
        SelectionFields: [ ID, title, author.name ],
        LineItem: [
        
            { Value: ID },
            { Value: title },
            { Value: author.name },  
            { Value: genres}            
        ],
        Facets: [
            {
                $Type: 'UI.CollectionFacet',
                Label: 'Book Info',
                Facets: [
                    {$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#Main', Label: 'Main Facet'},
                    {$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#AuthorDetails', Label: 'Author Facet'}
                ] 
            }
        ],        
        FieldGroup#Main: {
            Data: [
                { Value: ID , Label : 'Book ID'},
                { Value: title },
                { Value: price_with_curr , ![@UI.Importance] , Label : 'Discounted price'}, //Emphasized 
                { Value: price , Label : 'Original price'},
                { Value: currency_code },  
            
             
            ]
        },
        FieldGroup#AuthorDetails: {
            Data: [
                { Value: author.name },
                { Value: author.age },
                { Value: author.alive, ![@UI.Hidden]} //Hide from UI        
            ]
        }
    }
);
 

//Create UI to Author application - Read only
annotate CatalogService.Authors with @(   
    UI: {
        HeaderInfo: {
            TypeName: 'Author',  
            TypeNamePlural: 'Authors',
            Title: { Value: ID },
            Description: { Value: name }
        },
        SelectionFields: [ ID, name ],
        LineItem: [
            
            { Value: ID },
            { Value: name }             
        ],
        Facets: [
            {
                $Type: 'UI.CollectionFacet',
                Label: 'Author Info',
                Facets: [
                    {$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#Main', Label: 'Main Facet'},
                    {$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#Detail', Label: 'Detail Facet'}
                ]
            }
        ],        
        FieldGroup#Main: {
            Data: [
                { Value: ID },
                { Value: name },
                { Value: age }            
            ]
        },
        FieldGroup#Detail : {
              Data: [
                { Value: activeyear},               
            ]
            
        },

        //Sorting the records in table 
        PresentationVariant : {
            SortOrder : [
                {
                    Property : ID, 
                    Descending : true
                }
            ],
            Visualizations : [
                '@UI.LineItem'
            ]
        }
    }
);