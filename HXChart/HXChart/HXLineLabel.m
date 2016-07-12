//
//  HXLineLabel.m
//  HXChart
//
//  Created by 佘红响 on 16/7/9.
//  Copyright © 2016年 she. All rights reserved.
//

#import "HXLineLabel.h"

@implementation HXLineLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setFont:[UIFont boldSystemFontOfSize:9.0f]];
        [self setTextColor: [UIColor darkGrayColor]];
        [self setTextAlignment:NSTextAlignmentCenter];
    }
    return self;
}

@end
