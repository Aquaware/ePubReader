//
//  ePubContainerParser.m
//  ePubReader
//
//  Created by KUDO IKUO on 12/07/14.
//  Copyright (c) 2012年 n/a. All rights reserved.
//

#import "ePubContainerParser.h"
#import "ePubOPFParser.h"


@implementation ePubContainerParser 
@synthesize rootfile, mediatype;

- ( void ) parse: ( NSString* ) filepathString parseError: ( NSError** ) error
{
    rootfile = nil;
    mediatype = nil;
    
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

- ( void )         parser: ( NSXMLParser* ) parser
          didStartElement: ( NSString* ) elementName
             namespaceURI: ( NSString* ) namespaceURI
            qualifiedName: ( NSString* ) qName
               attributes: ( NSDictionary* ) attributeDict
{
    if ( [ elementName isEqualToString: @"rootfile" ] ) {
        rootfile = [ attributeDict objectForKey: @"full-path" ];
    }
    
    if ( [ elementName isEqualToString: @"rootfile" ] ) mediatype = [ attributeDict objectForKey: @"media-type" ];  
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog( @"rootfile: %@", self.rootfile );
} 
@end
