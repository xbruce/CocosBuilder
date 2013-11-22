//
//  InspectorStroke.h
//  CocosBuilder
//
//  Created by Bruce Xiao on 11/20/13.
//
//

#import "InspectorValue.h"

@interface InspectorStroke : InspectorValue
{
    
}
@property (nonatomic, assign) float outlineWidth;
@property (nonatomic, retain) NSColor *outlineColor;

@end
