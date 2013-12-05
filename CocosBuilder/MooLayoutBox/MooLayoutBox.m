/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2013 Apportable Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "MooLayoutBox.h"
#import "ccMacros.h"
#import "CGPointExtension.h"

@implementation MooLayoutBox

static float roundUpToEven(float f)
{
    return ceilf(f/2.0f) * 2.0f;
}

- (void) layout
{
    if (_direction == MooLayoutBoxDirectionHorizontal)
    {
        // Get the maximum height
        float maxHeight = 0;
        for (CCNode* child in self.children)
        {
            float height = child.contentSize.height;
            if (height > maxHeight) maxHeight = height;
        }

        float contentWidth = 0;
        float contentHeight = 0;
        for (int i = 0; i < self.children.count; i ++) {
            CCNode *child = [self.children objectAtIndex:i];
            if ((_itemCount > 0 && i > 0 && i % _itemCount == 0)) {
                contentHeight += maxHeight + _spacingVertical;
            }
            CGSize childSize = child.contentSize;
            if (i < _itemCount || _itemCount == 0) {
                contentWidth += childSize.width + _spacingHorizontal;
            }
            if ((_itemCount > 0 && i == self.children.count - 1 && i % _itemCount != 0) || (i == self.children.count - 1 && _itemCount == 0)) {
                contentHeight += maxHeight + _spacingVertical;
            }
        }

        contentWidth -= _spacingHorizontal;
        if (contentWidth < 0) contentWidth = 0;
        contentHeight -= _spacingVertical;
        if (contentHeight < 0) contentHeight = 0;

        self.contentSize = CGSizeMake(roundUpToEven(contentWidth), roundUpToEven(contentHeight));

        // Position the nodes
        float width = 0;
        CGPoint layoutOffset = ccp(0, contentHeight);

        for (int i = 0; i < self.children.count; i++) {
            CCNode *child = [self.children objectAtIndex:i];
            if (_itemCount > 0 && i > 0 && i % _itemCount == 0) {
                width = 0;
                layoutOffset.y -= maxHeight + _spacingVertical;
            }
            
            CGSize childSize = child.contentSize;
            
            CGPoint offset = child.anchorPointInPoints;
            offset.y *= -1;
            CGPoint localPos = ccp(roundf(width), roundf((maxHeight-childSize.height)/2.0f));
            CGPoint position = ccpAdd(localPos, offset);
            position = ccpAdd(position, layoutOffset);
            
            child.position = position;
            
            width += childSize.width + _spacingHorizontal;
        }
    }
    else
    {
        // Get the maximum width
        float maxWidth = 0;
        for (CCNode* child in self.children)
        {
            float width = child.contentSize.width;
            if (width > maxWidth) maxWidth = width;
        }
        
        // Position the nodes
        float height = 0;
        for (CCNode* child in self.children)
        {
            CGSize childSize = child.contentSize;
            
            CGPoint offset = child.anchorPointInPoints;
            CGPoint localPos = ccp(roundf((maxWidth-childSize.width)/2.0f), roundf(height));
            CGPoint position = ccpAdd(localPos, offset);
            
            child.position = position;
            
            height += childSize.height;
            height += _spacingHorizontal;
        }
        
        // Account for last added increment
        height -= _spacingHorizontal;
        if (height < 0) height = 0;
        
        self.contentSize = CGSizeMake(roundUpToEven(maxWidth), roundUpToEven(height));
    }
}

- (void) setSpacingHorizontal:(float)spacingHorizontal {
    _spacingHorizontal = spacingHorizontal;
    [self needsLayout];
}

- (void) setSpacingVertical:(float)spacingVertical {
    _spacingVertical = spacingVertical;
    [self needsLayout];
}

- (void) setItemCount:(int)itemCount {
    _itemCount = itemCount;
    [self needsLayout];
}

@end
