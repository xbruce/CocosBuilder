//
//  InspectorShadow.m
//  CocosBuilder
//
//  Created by Bruce Xiao on 11/20/13.
//
//

#import "InspectorShadow.h"
#import "PositionPropertySetter.h"
#include "CocosBuilderAppDelegate.h"
#include "CCBWriterInternal.h"

@implementation InspectorShadow

- (void) setColor:(NSColor *)color {
    CGFloat r, g, b, a;
    
    color = [color colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
    
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    ccColor4B c = ccc4(r*255, g*255, b*255, a*255);
    
    NSValue* colorValue = [NSValue value:&c withObjCType:@encode(ccColor4B)];
    [selection setValue:colorValue forKey:[propertyName stringByAppendingString:@"Color"]];
    
    [self updateAnimateablePropertyValue: [CCBWriterInternal serializeColor4:c]];
}

- (NSColor *) color {
    NSValue *value = [selection valueForKey:[propertyName stringByAppendingString:@"Color"]];
    ccColor4B c;
    [value getValue:&c];
    return [NSColor colorWithCalibratedRed:c.r/255.0 green:c.g/255.0 blue:c.b/255.0 alpha:c.a/255.0];
}

- (void) setRadius:(float)radius {
    [[CocosBuilderAppDelegate appDelegate] saveUndoStateWillChangeProperty:propertyName];
    
    [selection setValue:[NSNumber numberWithFloat:radius] forKey:[propertyName stringByAppendingString:@"Radius"]];
    [self updateAffectedProperties];
}

- (float) radius {
    return [[selection valueForKey:[propertyName stringByAppendingString:@"Radius"]] floatValue];
}

- (void) updateAnimateableX:(float)x Y:(float)y {
    [self updateAnimateablePropertyValue:[NSArray arrayWithObjects:[NSNumber numberWithFloat:x], [NSNumber numberWithFloat:y], nil]];
}

- (float) offsetX {
    return [[self propertyForSelectionX] floatValue];
}

- (void) setOffsetX:(float)offsetX {
    [self setPropertyForSelectionX:[NSNumber numberWithFloat:offsetX]];
    [self updateAnimateableX:offsetX Y:self.offsetY];
}

- (float) offsetY {
    return [[self propertyForSelectionY] floatValue];
}

- (void) setOffsetY:(float)offsetY {
    [self setPropertyForSelectionY:[NSNumber numberWithFloat:offsetY]];
    [self updateAnimateableX:self.offsetX Y:offsetY];
}



@end
