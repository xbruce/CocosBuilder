//
//  JsonCCBXCocos2diPhoneWriter.m
//  CocosBuilder
//
//  Created by Bruce Xiao on 11/7/13.
//
//

#import "JsonCCBXCocos2diPhoneWriter.h"

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
    NSDictionary *nodeGraph = [doc objectForKey:@"nodeGraph"];
    jsControlled = [[doc objectForKey:@"jsControlled"] boolValue];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:nodeGraph options:NSJSONWritingPrettyPrinted error:&error];
    
    if (jsonData) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [data appendData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

@end
