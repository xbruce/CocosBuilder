//
//  InspectorStroke.m
//  CocosBuilder
//
//  Created by Bruce Xiao on 11/20/13.
//
//

#import "InspectorStroke.h"
#import "CCBWriterInternal.h"
#import "CocosBuilderAppDelegate.h"

@implementation InspectorStroke
- (void) setOutlineColor:(NSColor *)color {
    CGFloat r, g, b, a;
    
    color = [color colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
    
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    ccColor4B c = ccc4(r*255, g*255, b*255, a*255);
    
    NSValue* colorValue = [NSValue value:&c withObjCType:@encode(ccColor4B)];
    [selection setValue:colorValue forKey:[propertyName stringByAppendingString:@"Color"]];
    
    [self updateAnimateablePropertyValue: [CCBWriterInternal serializeColor4:c]];
}

- (NSColor *) outlineColor {
    NSValue *value = [selection valueForKey:[propertyName stringByAppendingString:@"Color"]];
    ccColor4B c;
    [value getValue:&c];
    return [NSColor colorWithCalibratedRed:c.r/255.0 green:c.g/255.0 blue:c.b/255.0 alpha:c.a/255.0];
}

- (void) setOutlineWidth:(float)radius {
    [[CocosBuilderAppDelegate appDelegate] saveUndoStateWillChangeProperty:propertyName];
    
    [selection setValue:[NSNumber numberWithFloat:radius] forKey:[propertyName stringByAppendingString:@"Width"]];
    [self updateAffectedProperties];
}

- (float) outlineWidth {
    return [[selection valueForKey:[propertyName stringByAppendingString:@"Width"]] floatValue];
}
@end
