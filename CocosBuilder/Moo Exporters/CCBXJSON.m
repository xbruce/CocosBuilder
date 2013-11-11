//
//  CCBXJSON.m
//  CocosBuilder
//
//  Created by Bruce Xiao on 11/11/13.
//
//

#import "CCBXJSON.h"
#import "JsonCCBXCocos2diPhoneWriter.h"

@implementation CCBXJSON

- (NSString *) extension {
    return @"json";
}

- (NSData *) exportDocument:(NSDictionary *)doc flattenPaths:(BOOL)flattenPaths {
    JsonCCBXCocos2diPhoneWriter *writer = [[[JsonCCBXCocos2diPhoneWriter alloc] init] autorelease];
    [writer writeDocument:doc];
    
    return [[writer.data copy] autorelease];
}

- (void) dealloc {
    [super dealloc];
}

@end
