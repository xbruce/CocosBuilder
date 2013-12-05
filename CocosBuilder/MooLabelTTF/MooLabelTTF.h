//
//  MooLabelTTF.h
//  CocosBuilder
//
//  Created by Bruce Xiao on 13-12-4.
//
//

#import "CCNode.h"

@interface MooLabelTTF : CCNode
{
    NSString *_string;
    CGFloat _fontSIze;
    NSString *_fontName;
    NSTask *syntaxTask;
}

@property (nonatomic, retain) NSString* fontName;
@property (nonatomic, assign) float fontSize;
- (id) initWithString:(NSString *)str fontName:(NSString *)name fontSize:(CGFloat)size;
- (void) setString:(NSString *)label;

@end
