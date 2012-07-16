//
//  ePubOPFParser.h
//  ePubReader
//
//  Created by KUDO IKUO on 12/07/14.
//  Copyright (c) 2012年 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ePubBook.h"

@class ePubOPFParser;

typedef void ( ^ePubOffParserFinished ) ( ePubOPFParser* parser, BOOL success );

@interface ePubOPFParser : NSObject < NSXMLParserDelegate >

@property ( nonatomic, copy )  ePubOffParserFinished completion;
@property ( nonatomic, readonly, strong ) ePubMeta* meta;
@property ( nonatomic, readonly, strong ) NSMutableArray* files;
@property ( nonatomic, readonly, strong ) NSMutableArray* pages;
@property ( nonatomic, readonly, strong ) NSString* version;
@property ( nonatomic, readonly, assign ) ePubPageDirection pageDirection;

- ( ePubFileType ) checkMediaType: ( NSString* ) mediaType;
- ( void ) parse: ( NSString* ) filepathString parseError: ( NSError** ) error;

@end
