using my.bookshop as my from '../db/data-model';

service CatalogService {
  entity Books @readonly as projection on my.Books;
  entity Authors @readonly as projection on my.Authors;
  entity Orders  as projection on my.Orders;
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


        SelectionFields: [ title , author.name ],
        QuickViewFacets  : [ //Create Quick view UI for table
                {
                    $Type : 'UI.ReferenceFacet',
                    Target : '@UI.FieldGroup#QuickView',
                    Label : 'Age'
                },
        ],
        LineItem: {
            $value: [
                
                { Value: ID , 
                    Criticality : uiStockStatus, //Dynamic code for criticality i.e based on stock quantity 
                    ![@HTML5.CssDefaults] : { //Adjust the column width 
                        $Type : 'HTML5.CssDefaultsType',
                        width : '5rem'
                }
                },
                { Value: title , ![@UI.Importance] : #High},  
                //Importance helps to visualize the table content with priority. 
                //i.e Mobile screen shows Book title and Author name at the first page
                { Value: author.name , ![@UI.Importance] : #High},  
                { Value: genres},
                { Value: stock , 
                    Criticality : uiStockStatus, //Dynamic code for criticality i.e based on stock quantity 
                     CriticalityRepresentation : #WithoutIcon,
                    ![@HTML5.CssDefaults] : { //Adjust the column width 
                            $Type : 'HTML5.CssDefaultsType',
                            width : '100%'
                    } }          
            ]
        },
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
                { @Common.SemanticObject: 'QuickView', Value: ID , Label : 'Book ID' , $Type : 'UI.DataField'},
                { Value: title },
                { Value: price_with_curr , ![@UI.Importance] , Label : 'Discounted price'}, //Emphasized 
                { Value: price , Label : 'Original price'},
                { Value: stock},
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


annotate CatalogService.Authors with @(
    UI.QuickViewFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#QuickViewPOC_FieldGroup_1'
        }
    ],
    UI.FieldGroup #QuickViewPOC_FieldGroup_1 : {
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'Author Age',
                Value : age
            }
        ]
    }
);