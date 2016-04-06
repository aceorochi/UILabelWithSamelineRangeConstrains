//
//  UILabel+Extension.h
//  LabelWithSamelineRangeConstrains
//
//  Created by Pei Wu on 4/5/16.
//  Copyright © 2016 Pei Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

- (void)updateLineBreaksBySameLineRangeConstrains:(NSArray *)sameLineRanges
                               withConstrainWidth:(CGFloat)constrainWidth;

@end
