//
//  HXChart.h
//  HXChart
//
//  Created by 佘红响 on 16/7/9.
//  Copyright © 2016年 she. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HXChart;

//范围
struct HXRange {
    CGFloat max;
    CGFloat min;
    NSUInteger numOfStage;
};
typedef struct HXRange CGRange;
CG_INLINE CGRange CGRangeMake(CGFloat max, CGFloat min, NSUInteger numOfStage);

CG_INLINE CGRange
CGRangeMake(CGFloat max, CGFloat min, NSUInteger numOfStage){
    CGRange p;
    p.max = max;
    p.min = min;
    p.numOfStage = numOfStage;
    return p;
}

static const CGRange CGRangeZero = {0,0, 1};

@protocol HXChartDataSource <NSObject>

@required

/** 返回x轴的坐标 */
- (NSArray<NSString *> *)xCoordinatesInChart:(HXChart *)chart;

/** 返回值得数组 */
- (NSArray<NSArray<NSString *> *> *)valuesInChart:(HXChart *)chart;

@optional
/** 返回折现的颜色数组 */
- (NSArray<UIColor *> *)colorsInChart:(HXChart *)chart;

/** 返回点击小圆点弹出框背景图片名称的数组 */
- (NSArray<NSString *> *)imageNamesInChart:(HXChart *)chart;

/** 返回y轴的范围 */
- (CGRange)rangeForYAsisInChart:(HXChart *)chart;

/** 返回y轴的坐标 */
- (NSArray<NSString *> *)yCoordinatesInChart:(HXChart *)chart;

/** 判断线上的点是否可以点击 */
- (BOOL)canClickPointBtnInChart:(HXChart *)chart;

/** 判断第一条线的最后一个popBtn是否显示 */
- (BOOL)showLastPopBtnInChart:(HXChart *)chart;

@end

@interface HXChart : UIView

@property (nonatomic, weak) id<HXChartDataSource> dataSource;      /**< 数据源 */

@property (nonatomic, assign) BOOL showXLine;  /**< 是否显示网格的竖线 */

@property (nonatomic, assign) BOOL showYLine;  /**< 是否显示网格的横线 */

@end
