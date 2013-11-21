//
//  JsonCCBXCocos2diPhoneWriter.m
//  CocosBuilder
//
//  Created by Bruce Xiao on 11/7/13.
//
//

#import "JsonCCBXCocos2diPhoneWriter.h"
#import "JSONKit.h"

@implementation JsonCCBXCocos2diPhoneWriter

@synthesize data;

- (id) init {
    self = [super init];
    if (!self) return NULL;
    
    data = [[NSMutableData alloc] init];
    stringCacheLookup = [[NSMutableDictionary alloc] init];
    return self;
}

- (void) dealloc {
    [data release];
    [stringCacheLookup release];
    [super dealloc];
}


- (void) writeDocument:(NSDictionary *)doc {
    NSMutableDictionary *pNodeGraph = [doc objectForKey:@"nodeGraph"];
    [pNodeGraph setObject:[doc objectForKey:@"sequences"] forKey:@"sequences"];
    
    jsControlled = [[doc objectForKey:@"jsControlled"] boolValue];
    [data appendData:[pNodeGraph JSONData]];
}

@end
