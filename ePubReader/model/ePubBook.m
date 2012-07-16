//
//  ePubBook.m
//  ePubReader
//
//  Created by KUDO IKUO on 12/07/16.
//  Copyright (c) 2012年 n/a. All rights reserved.
//

#import "ePubBook.h"

@implementation ePubBook
@synthesize absolutePath, contentsDir, meta, files, pages;
@end

// ----------------------------------------------

@implementation ePubMeta 

@synthesize titles, language, identifier;
@synthesize idname, date, creators, publisher, modified;

- ( BOOL ) isValid
{
    if( titles && language && identifier ) return YES; else return NO;
}

@end 

// ----------------------------------------------

@implementation ePubFile 
@synthesize  identifier, properties, href, mediaType, fileType;
@end

// ----------------------------------------------
@implementation ePubPage
@synthesize idref, linear, fileIndex, href;
@end
// ----------------------------------------------