//
//  ePubOPFParser.m
//  ePubReader
//
//  Created by KUDO IKUO on 12/07/14.
//  Copyright (c) 2012年 n/a. All rights reserved.
//

#import "ePubOPFParser.h"



@interface  ePubOPFParser ()
{
    BOOL inPackage;
    BOOL inMetadata; 
    BOOL inModified;
    BOOL inManifest;
    BOOL inSpine;
    int spineCount;
    NSMutableString* text;
}

@end

@implementation ePubOPFParser 
@synthesize completion;
@synthesize meta, files, pages, version, pageDirection;


- ( ePubFileType ) checkMediaType: ( NSString* ) mediaType
{
    ePubFileType type = ePubFileTypeOthers;
    
    if( [ mediaType compare: @"application/xhtml+xml" ] ) type = ePubFileTypeXhtml;
    else if( [ mediaType compare: @"image/jpeg" ] ) type = ePubFileTypeJpeg;
    else if( [ mediaType compare: @"image/jpeg" ] ) type = ePubFileTypeCss;
    
    return type;
}

- ( void ) parse: ( NSString* ) filepathString parseError: ( NSError** ) error
{
    NSData *xml = [ NSData dataWithContentsOfFile: filepathString ];
    NSLog( @"xml: %@", [[NSString alloc] initWithData:xml encoding:NSUTF8StringEncoding] );
    NSXMLParser *parser = [ [ NSXMLParser alloc] initWithData: xml ];
    
    [ parser setDelegate: self ];
    [ parser setShouldProcessNamespaces: NO ];
    [ parser setShouldReportNamespacePrefixes: NO ];
    [ parser setShouldResolveExternalEntities: NO ];
    [ parser parse ];
    NSError *parseError = [parser parserError];
    if ( parseError && error ) *error = parseError;
}

#pragma mark NSXMLParser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    inPackage = NO;
    inMetadata = NO;
    inModified = NO;
    inManifest = NO;
    inSpine = NO;
    spineCount = 0;
    
    meta = [[ ePubMeta alloc ] init ];
    meta.titles = [ [ NSMutableArray alloc ] initWithCapacity: 0 ];
    meta.creators = [ [ NSMutableArray alloc ] initWithCapacity: 0 ];
    
    if( files ) {
        [ files removeAllObjects ];
    }
    else{ 
        files = [ [ NSMutableArray alloc ] initWithCapacity: 0 ];
    }
    
    if( pages ) { 
        [ pages removeAllObjects ];
    }
    else {
        pages = [ [ NSMutableArray alloc ] initWithCapacity: 0 ];
    }
}

// 要素の開始
- ( void )         parser: ( NSXMLParser* ) parser
          didStartElement: ( NSString* ) elementName
             namespaceURI: ( NSString* ) namespaceURI
            qualifiedName: ( NSString* ) qName
               attributes: ( NSDictionary* ) attributeDict
{
    
    if ( [ elementName isEqualToString: @"package" ] ) {
        inPackage = YES;
        version = [ attributeDict objectForKey: @"version" ];
    }
    
    else if ( [ elementName isEqualToString: @"spine" ] ) {
        NSString* direction = [ attributeDict objectForKey: @"page-progression-direction" ];
        if( [ direction compare: @"ltr" ] ) pageDirection = ePubPageDirectionLtr;
        NSLog( @"direction: %@", direction );
        inSpine = YES;
    }
    
    else if ( [ elementName isEqualToString: @"metadata" ] ) {
        inMetadata = YES;
    }
    
    else if ( [ elementName isEqualToString: @"manifest" ] ) {
        inManifest = YES;
    }
    
    
    if( inPackage && inMetadata ) {
        
        if ( [ elementName isEqualToString: @"dc:title" ] ||
             [ elementName isEqualToString: @"dc:date" ] ||
             [ elementName isEqualToString: @"dc:creator" ] ||
             [ elementName isEqualToString: @"dc:publisher" ] ||
             [ elementName isEqualToString: @"dc:language" ]            
             ) {        
            text = nil;
        }
        else if ( [ elementName isEqualToString: @"meta" ] ) {        
            
            NSString* property = [ attributeDict objectForKey: @"property" ];
            if( [ property isEqualToString: @"dcterms:modified" ] )  text = nil;
            inModified = YES;
        }
        else if ( [ elementName isEqualToString: @"dc:identifier" ] ) {        
            meta.idname = [ attributeDict objectForKey: @"id" ];
            text = nil;
        }      
    }
    
    if( inPackage && inManifest ) {
        
        if ( [ elementName isEqualToString: @"item" ] ) {  
            ePubFile* item = [ [ ePubFile alloc ] init ];
            item.identifier = [ attributeDict objectForKey: @"id" ];
            item.properties = [ attributeDict objectForKey: @"properties" ];
            item.href = [ attributeDict objectForKey: @"href" ];
            item.mediaType = [ attributeDict objectForKey: @"media-type" ]; 
            item.fileType = [ self checkMediaType : item.mediaType  ];
            
            [ files addObject: item ];
        }
    }
    
    if( inPackage && inSpine ) {
        
        if ( [ elementName isEqualToString: @"itemref" ] ) {  
            ePubPage* page = [ [ ePubPage alloc ] init ];
            page.idref = [ attributeDict objectForKey: @"idref" ];
            NSString* linear = [ attributeDict objectForKey: @"linear" ];
            if( [ linear compare: @"yes" ] ) page.linear = YES; else page.linear = NO;
            
            [ pages addObject: page ];
        }
    }   
    
}

- ( void ) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if( !text ) text = [ NSMutableString stringWithString:@"" ];
    [ text appendString: string ];
   // NSLog( @"text: %@", text );;
}

- ( void )         parser: ( NSXMLParser* ) parser
            didEndElement: ( NSString* ) elementName
             namespaceURI: ( NSString* ) namespaceURI
            qualifiedName: ( NSString* ) qName
{
    if ( [ elementName isEqualToString: @"package" ] ) inPackage = NO;
    else if ( [ elementName isEqualToString: @"metadata" ] ) inMetadata = NO;    
    else if ( [ elementName isEqualToString: @"manifest" ] ) inManifest = NO;
    else if ( [ elementName isEqualToString: @"spine" ] ) inSpine = NO;
    
    if( inPackage && inMetadata ) {
        if ( [ elementName isEqualToString: @"dc:title" ]  ) { 
            [ meta.titles addObject:  text ];
            text = nil;
        }
        
        else if ( [ elementName isEqualToString: @"dc:identifier" ]  ) {
            meta.identifier = text;
            text = nil;
        }
        
        else if ( [ elementName isEqualToString: @"dc:date" ]  ) {
            meta.date = text;
            text = nil;
        }
        else if ( [ elementName isEqualToString: @"dc:creator" ]  ) {
            [ meta.creators addObject: text ];
            text = nil;
        }
        
        else if ( [ elementName isEqualToString: @"dc:publisher" ]  ) {
            meta.publisher = text;
            text = nil;
        }
        
        else if ( [ elementName isEqualToString: @"dc:language" ]  ) {
            meta.language = text;
            text = nil;
        }
        
        if ( [ elementName isEqualToString: @"meta" ] ) {        
            if( inModified ) {
                meta.modified = text;
                text = nil;
                inModified = NO;
            }
        }
    }
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{

    for( int i = 0; i < [ pages count ]; i++ ) {
        ePubPage* page = [ pages objectAtIndex: i ];
        page.fileIndex = -1;
        for( int j = 0; j < [ files count ]; j++ ) {
            ePubFile* file = [ files objectAtIndex: j ];
            if( [ page.idref isEqualToString: file.identifier ] ) {
                page.fileIndex = j;
                page.href = file.href;
                break;
            }
        }
    }
  

    
    if ( completion ) {
        completion( self, YES );
    }
}

@end
