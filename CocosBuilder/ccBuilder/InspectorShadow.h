//
//  InspectorShadow.h
//  CocosBuilder
//
//  Created by Bruce Xiao on 11/20/13.
//
//

#import "InspectorValue.h"

@interface InspectorShadow : InspectorValue
{
}

@property (nonatomic, assign) float offsetX;
@property (nonatomic, assign) float offsetY;
@property (nonatomic, assign) float radius;

@property (nonatomic, retain) NSColor *color;



@end
