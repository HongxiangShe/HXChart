//
//  ViewController.m
//  HXChart
//
//  Created by 佘红响 on 16/7/9.
//  Copyright © 2016年 she. All rights reserved.
//

#import "ViewController.h"
#import "HXChart.h"

@interface ViewController () <HXChartDataSource>

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, weak) HXChart *chart;         /**< 折线图 */

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
}

/**
 *  初始化方法
 */
- (void)setup {
    [self.contentView layoutIfNeeded];
    
    HXChart *chart = [[HXChart alloc] init];
    chart.dataSource = self;
    chart.showXLine = NO;
    chart.showYLine = NO;
    self.chart = chart;
    chart.frame = self.contentView.bounds;
    [self.contentView addSubview:chart];
    
    
}

#pragma Mark - HXChartDataSource
///**
// *  返回y轴的坐标
// */
//- (NSArray<NSString *> *)yCoordinatesInChart:(HXChart *)chart {
//    return @[@"0.80", @"0.82", @"0.84", @"0.86", @"0.88", @"0.90", @"0.92", @"0.94", @"0.96", @"0.98", @"1.00", @"1.02", @"1.04", @"1.06", @"1.08", @"1.10", @"1.12", @"1.14", @"1.16", @"1.18"];
//}

/**
 *  返回x轴的坐标
 */
- (NSArray<NSString *> *)xCoordinatesInChart:(HXChart *)chart {
    return @[@"16/01", @"", @"16/03", @"", @"16/05", @"", @"16/07"];
}

/**
 *  返回坐标点的值
 */
- (NSArray<NSArray<NSString *> *> *)valuesInChart:(HXChart *)chart {
    return @[
             @[@"0.81", @"0.82", @"0.92", @"0.88", @"0.89", @"0.92", @"1.12"],
             @[@"0.91", @"0.92", @"0.82", @"0.99", @"1.11", @"0.94", @"1.02"]
             ];
}

- (NSArray<UIColor *> *)colorsInChart:(HXChart *)chart {
    return @[
             [UIColor colorWithRed:104/255.0 green:210/255.0 blue:198/255.0 alpha:1.0],
             [UIColor colorWithRed:239 / 255.0f green:83 / 255.0f blue:68 / 255.0f alpha:1]
             
             ];
}

- (NSArray<NSString *> *)imageNamesInChart:(HXChart *)chart {
    return @[
             @"blue"
             ];
}

- (CGRange)rangeForYAsisInChart:(HXChart *)chart {
    return CGRangeMake(1.80, 0.80, 18);
}

/**
 *  判断线上的点是否可以点击 (默认为YES)
 *
 */
- (BOOL)canClickPointBtnInChart:(HXChart *)chart {
    return YES;
}

/**
 *  判断第一条线的最后一个popBtn是否显示 (默认为YES)
 *
 */
- (BOOL)showLastPopBtnInChart:(HXChart *)chart {
    return YES;
}

@end
