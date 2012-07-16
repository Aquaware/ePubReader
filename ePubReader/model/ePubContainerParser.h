//
//  ePubContainerParser.h
//  ePubReader
//
//  Created by KUDO IKUO on 12/07/14.
//  Copyright (c) 2012年 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ePubContainerParser : NSObject < NSXMLParserDelegate >

- ( void ) parse: ( NSString* ) filepathString parseError: ( NSError** ) error;
@property ( nonatomic, strong ) NSString* rootfile;
@property ( nonatomic, strong ) NSString* mediatype;

@end
