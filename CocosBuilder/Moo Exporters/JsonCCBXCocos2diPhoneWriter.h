//
//  JsonCCBXCocos2diPhoneWriter.h
//  CocosBuilder
//
//  Created by Bruce Xiao on 11/7/13.
//
//

#import <Foundation/Foundation.h>

@interface JsonCCBXCocos2diPhoneWriter : NSObject
{
    NSMutableData *data;
    NSMutableDictionary *stringCacheLookup;
    BOOL jsControlled;
}

@property (nonatomic, readonly) NSMutableData *data;

- (void) writeDocument:(NSDictionary *)doc;

@end
