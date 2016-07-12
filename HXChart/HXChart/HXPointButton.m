//
//  HXPointButton.m
//  HXChart
//
//  Created by 佘红响 on 16/7/10.
//  Copyright © 2016年 she. All rights reserved.
//

#import "HXPointButton.h"

@implementation HXPointButton

//- (instancetype)initWithFrame:(CGRect)frame {
//    
//    frame.size.height = frame.size.width = frame.size.width >= frame.size.height ? frame.size.height : frame.size.width;
//    
//    if (self = [super initWithFrame:frame]) {
//        self.clipsToBounds = YES;
//        self.layer.cornerRadius = frame.size.width / 2;
//    }
//    return self;
//}

- (void)setHighlighted:(BOOL)highlighted{}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(22.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(22.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, - 0.5 * widthDelta, - 0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end
