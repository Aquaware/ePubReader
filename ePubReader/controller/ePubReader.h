//
//  ePubReader.h
//  ePubReader
//
//  Created by KUDO IKUO on 12/07/14.
//  Copyright (c) 2012年 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLoadedEpubInfo @"LoadedEpubInfo"

@class ePubMeta;
@class iPubOPFParser;
@class ePubBook;


@interface ePubReader : NSObject

@property ( nonatomic, strong ) ePubBook* book;

- ( BOOL ) openEpubFile;
- ( BOOL ) unzipFile: ( NSString* ) filepath outputDir: ( NSString* ) outdir;



@end
