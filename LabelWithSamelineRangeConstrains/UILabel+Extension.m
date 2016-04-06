//
//  UILabel+Extension.m
//  LabelWithSamelineRangeConstrains
//
//  Created by Pei Wu on 4/5/16.
//  Copyright © 2016 Pei Wu. All rights reserved.
//

#import "UILabel+Extension.h"
#import <CoreText/CoreText.h>

@implementation UILabel (Extension)

- (void)updateLineBreaksBySameLineRangeConstrains:(NSArray *)sameLineRanges withConstrainWidth:(CGFloat)constrainWidth {
  if (constrainWidth == 0) {
    return;
  }
  
  NSMutableAttributedString *tmpStr = self.attributedText ?
  [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText] :
  [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName:self.font}];
  static NSAttributedString *newLineStr = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    newLineStr = [[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName:self.font}];
  });
  NSInteger rangeOffset = 0;
  NSRange lastRange = NSMakeRange(0, 0);
  for (id obj in sameLineRanges) {
    NSAssert([obj isKindOfClass:[NSValue class]], @"Unexpected type from NSValue, here it should be an NSRange");
    NSRange range = [(NSValue *)obj rangeValue];
    NSAssert(range.location >= lastRange.location+ lastRange.length, @"Overlapped ranges!");
    lastRange = range;
    range.location += rangeOffset;
    range.length = MIN(range.length, tmpStr.length - range.location);
    
    CGFloat leadingWidth = [self attributedString:tmpStr
                caculateLeadingOccupiedWithLength:range.location
                               withConstrainWidth:constrainWidth];
    if (![self canFitWidth:constrainWidth-leadingWidth withAttributedString:[tmpStr attributedSubstringFromRange:range]]) {
      [tmpStr insertAttributedString:newLineStr atIndex:range.location];
      rangeOffset++;
    }
    
  }
  self.attributedText ? (self.attributedText = tmpStr) : (self.text = tmpStr.string);
}

- (CGFloat)attributedString:(NSAttributedString*)attributedString caculateLeadingOccupiedWithLength:(NSUInteger)length withConstrainWidth:(CGFloat)constrainWidth {
  if (length == 0)  {
    return 0.0;
  }
  if ([[NSCharacterSet newlineCharacterSet] characterIsMember:[attributedString.string characterAtIndex:length-1]]) {
    return 0.0;
  }
  NSAttributedString *leadingStr = [attributedString attributedSubstringFromRange:NSMakeRange(0, length)];
  CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)leadingStr);
  CGMutablePathRef framePath = CGPathCreateMutable();
  CGPathAddRect(framePath, nil, CGRectMake(0, 0, constrainWidth, 10000));
  CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter,
                                                 CFRangeMake(0, CFAttributedStringGetLength((CFAttributedStringRef)leadingStr)),
                                                 framePath,
                                                 NULL);
  CFArrayRef lines = CTFrameGetLines(frameRef);
  NSUInteger lineCount = CFArrayGetCount(lines);
  CTLineRef lastLine = CFArrayGetValueAtIndex(lines, lineCount-1);
  CGFloat leadingWidth = CTLineGetTypographicBounds(lastLine, NULL, NULL, NULL);
  CFRelease(framePath);
  CFRelease(frameRef);
  CFRelease(frameSetter);
  return leadingWidth;
}

- (BOOL)canFitWidth:(CGFloat)constrainWidth withAttributedString:(NSAttributedString *)str {
  CGRect strRect = [str boundingRectWithSize:CGSizeMake(10000, [self getMaxFontHeight])
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     context:nil];
  return strRect.size.width <= constrainWidth;
}

- (CGFloat) getMaxFontHeight {
  __block CGFloat maxHeight = 0;
  if (self.attributedText) {
    [self.attributedText enumerateAttribute:NSFontAttributeName
                                    inRange:NSMakeRange(0, [self.attributedText length])
                                    options:0
                                 usingBlock:^(id value, NSRange range, BOOL *stop) {
                                   if ([value isKindOfClass:[UIFont class]]) {
                                     UIFont *font = value;
                                     maxHeight = MAX(maxHeight, font.lineHeight);
                                   }
                                 }];
  } else {
    maxHeight = self.font.lineHeight;
  }
  return ceil(maxHeight);
}

@end
