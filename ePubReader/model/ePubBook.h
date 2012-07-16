//
//  ePubBook.h
//  ePubReader
//
//  Created by KUDO IKUO on 12/07/16.
//  Copyright (c) 2012年 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kePubContainer @"/META-INF/container.xml"

typedef enum
{
    ePubFileTypeXhtml = 0,
    ePubFileTypeJpeg = 1,
    ePubFileTypeCss = 2,
    ePubFileTypeOthers = 3
    
}  ePubFileType;

typedef enum
{
    ePubPageDirectionLtr = 0    
}  ePubPageDirection;

@class ePubMeta;

@interface ePubBook : NSObject

@property ( nonatomic, strong ) NSString* absolutePath;
@property ( nonatomic, strong ) NSString* contentsDir;
@property ( nonatomic, strong ) ePubMeta* meta;
@property ( nonatomic, strong ) NSArray* files;
@property ( nonatomic, strong ) NSArray* pages;

@end


//-----------------------------------------------------

@interface ePubMeta : NSObject

@property ( nonatomic, strong ) NSMutableArray* titles;
@property ( nonatomic, strong ) NSString* language;
@property ( nonatomic, strong ) NSString* identifier;

@property ( nonatomic, strong ) NSString* idname;
@property ( nonatomic, strong ) NSString* date;
@property ( nonatomic, strong ) NSMutableArray* creators;
@property ( nonatomic, strong ) NSString* publisher;
@property ( nonatomic, strong ) NSString* modified;

- ( BOOL ) isValid;

@end

// -------------------------------------------------------------------

@interface ePubFile : NSObject

@property ( nonatomic, strong ) NSString* identifier;
@property ( nonatomic, strong ) NSString* properties;
@property ( nonatomic, strong ) NSString* href;
@property ( nonatomic, strong ) NSString* mediaType;
@property ( nonatomic, assign ) ePubFileType fileType;

@end


// -------------------------------------------------------------------

@interface ePubPage : NSObject

@property ( nonatomic, strong ) NSString* idref;
@property ( nonatomic, assign ) BOOL linear;
@property ( nonatomic, assign ) int fileIndex;
@property ( nonatomic, strong ) NSString* href;

@end

// -------------------------------------------------------------------

