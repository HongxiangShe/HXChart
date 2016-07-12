//
//  HXChart.m
//  HXChart
//
//  Created by 佘红响 on 16/7/9.
//  Copyright © 2016年 she. All rights reserved.
//

#import "HXChart.h"
#import "HXLineChart.h"

@interface HXChart ()

@property (nonatomic, weak) HXLineChart *lineChart;    /**< 折线图 */

@end

@implementation HXChart

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupLineChart];
    }
    return self;
}

- (void)awakeFromNib {
    [self setupLineChart];
}

- (void)setupLineChart {
    HXLineChart *lineChart = [[HXLineChart alloc] init];
    [self addSubview:lineChart];
    self.lineChart = lineChart;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lineChart.frame = CGRectMake(0, 0, self.frame.size.width - 5, self.frame.size.height);
}

- (void)setDataSource:(id<HXChartDataSource>)dataSource {
    _dataSource = dataSource;
    
    [self.lineChart layoutIfNeeded];
    if ([self.dataSource respondsToSelector:@selector(colorsInChart:)]) {
        self.lineChart.colors = [self.dataSource colorsInChart:self];
    }
    
    if ([self.dataSource respondsToSelector:@selector(imageNamesInChart:)]) {
        self.lineChart.imageNames = [self.dataSource imageNamesInChart:self];
    }
    
    if ([self.dataSource respondsToSelector:@selector(canClickPointBtnInChart:)]) {
        self.lineChart.canClickButton = [self.dataSource canClickPointBtnInChart:self];
    }
    
    if ([self.dataSource respondsToSelector:@selector(showLastPopBtnInChart:)]) {
        self.lineChart.showLastPopBtn = [self.dataSource showLastPopBtnInChart:self];
    }
    
    if ([self.dataSource respondsToSelector:@selector(yCoordinatesInChart:)]) {
        NSArray<NSString *> *yCoordinates = [self.dataSource yCoordinatesInChart:self];
        self.lineChart.yCoordinates = yCoordinates;
    } else if ([self.dataSource respondsToSelector:@selector(rangeForYAsisInChart:)]) {
        self.lineChart.yCoordinates = [self separatorRange:[self.dataSource rangeForYAsisInChart:self]];
    }
    
    NSArray<NSString *> *xCoordinates = [self.dataSource xCoordinatesInChart:self];
    self.lineChart.xCoordinates = xCoordinates;
    
    NSArray<NSArray *> *pointValues = [self.dataSource valuesInChart:self];
    self.lineChart.pointValues = pointValues;
    
    
}

- (void)setShowXLine:(BOOL)showXLine {
    _showXLine = showXLine;
    
    self.lineChart.showXLine = showXLine;
}

- (void)setShowYLine:(BOOL)showYLine {
    _showYLine = showYLine;
    
    self.lineChart.showYLine = showYLine;
}

- (NSArray<NSString *> *)separatorRange:(CGRange)range {
    CGFloat max = range.max;
    CGFloat min = range.min;
    NSUInteger numOfStage = range.numOfStage;
    CGFloat minus = [NSString stringWithFormat:@"%.2f", (max - min) / numOfStage].floatValue;
    
    NSMutableArray<NSString *> *arr = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numOfStage + 2; i++) {
        if (min + (i - 1) * minus > max && i > 0) {
            NSString *value = [NSString stringWithFormat:@"%.2f", min + i * minus];
            [arr addObject:value];
            break;
        }
        if (min + i * minus < max && i == numOfStage + 1) {
            NSString *value = [NSString stringWithFormat:@"%.2f", min + i * minus];
            [arr addObject:value];
            NSString *lastValue = [NSString stringWithFormat:@"%.2f", min + (i + 1) * minus];
            [arr addObject:lastValue];
            break;
        }
        
        if (min + (i - 1) * minus < max && min + i * minus > max && i == numOfStage + 1) {
            NSString *lastValue = [NSString stringWithFormat:@"%.2f", min + (i + 1) * minus];
            [arr addObject:lastValue];
            break;
        }
        
        NSString *value = [NSString stringWithFormat:@"%.2f", min + i * minus];
        [arr addObject:value];
    }
    
    return arr;
}

@end
