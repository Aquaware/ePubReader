//
//  ePubReader.m
//  ePubReader
//
//  Created by KUDO IKUO on 12/07/14.
//  Copyright (c) 2012年 n/a. All rights reserved.
//

#import "ePubReader.h"
#import "ZipArchive.h"
#import "ePubContainerParser.h"
#import "ePubOPFParser.h"
#import "ePubBook.h"

@implementation ePubReader
@synthesize book;

- ( BOOL ) openEpubFile
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"ehon" ofType:@"epub"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString* ePubDir = [ NSString stringWithFormat: @"%@/unzipped" , [ paths objectAtIndex: 0 ] ];
    
    if ( ![ self unzipFile: path outputDir: ePubDir ] ) return NO;
    
    NSError* error;
    ePubContainerParser* container = [ [ ePubContainerParser alloc ] init ];
    
    NSString* xmlFile = [ NSString stringWithFormat: @"%@%@", ePubDir, kePubContainer ];
    [ container parse: xmlFile parseError: &error ];
    
    ePubOPFParser* opf = [ [ ePubOPFParser alloc ] init ];
    NSString* opfpath = [ NSString stringWithFormat: @"%@/%@", ePubDir, container.rootfile ];
    NSRange range = [ container.rootfile rangeOfString: @"/" options:NSCaseInsensitiveSearch | NSBackwardsSearch ];
    
    NSString* contentsDir;
    if( range.location == 0 ) {
        contentsDir = @"/";
    }
    else {
        contentsDir = [ container.rootfile substringToIndex:  range.location ];
    }
    NSLog( @"contents dir: %@", contentsDir );
    
    opf.completion = ^( ePubOPFParser* parser, BOOL success ) {
        
        book = [ [ ePubBook alloc ] init ];
        self.book.absolutePath = ePubDir;
        self.book.contentsDir = contentsDir;
        self.book.meta = parser.meta;
        self.book.files = parser.files;
        self.book.pages = parser.pages;
        
        for( int i = 0; i < [ parser.meta.titles count ]; i++ ) {
            NSLog( @"title: %@", [ parser.meta.titles objectAtIndex: i ] );
        }
        
        for( int i = 0; i < [ parser.meta.creators count ]; i++ ) {
            NSLog( @"creator: %@", [ parser.meta.creators objectAtIndex: i ] );
        }
        
        NSLog( @"idname: %@", parser.meta.idname );
        NSLog( @"id: %@", parser.meta.identifier );
        NSLog( @"version: %@", parser.version );    
        NSLog( @"date: %@", parser.meta.date );
        NSLog( @"publisher: %@", parser.meta.publisher );
        NSLog( @"modified: %@", parser.meta.modified );
        NSLog( @"language: %@", parser.meta.language );
        
        for( int i = 0; i < [ parser.files count ]; i++ ) {
            ePubFile* file = [ parser.files objectAtIndex: i ];
            NSLog( @"file... id:%@  property:%@  href:%@", file.identifier, file.properties, file.href );
        }
        
        for( int i = 0; i < [ parser.pages count ]; i++ ) {
            ePubPage* page = [ parser.pages objectAtIndex: i ];
            NSLog( @"page... id:%@  index:%d", page.idref, page.fileIndex );
        }        
        
        NSDictionary* dic = [NSDictionary dictionaryWithObject: self.book forKey:@"ePubBook"];
        NSNotification*n = [ NSNotification notificationWithName: kLoadedEpubInfo object:self userInfo: dic ];
        [ [ NSNotificationCenter defaultCenter] postNotification: n ];

    };
    
    [ opf parse: opfpath parseError: &error ];

    
    return YES;
}

- ( BOOL ) unzipFile: ( NSString* ) filepath outputDir: ( NSString* ) outdir
{    
    ZipArchive *archive = [[ZipArchive alloc] init];
    
    if( ![ archive UnzipOpenFile: filepath ] ) goto error;    
    if( ![ archive UnzipFileTo: outdir  overWrite:YES ] ) goto error;
    [ archive UnzipCloseFile ];
    
    return YES;
    
error:
    [ archive UnzipCloseFile ];
    return NO;
}

@end
