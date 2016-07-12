//
//  HXLineView.m
//  HXChart
//
//  Created by 佘红响 on 16/7/9.
//  Copyright © 2016年 she. All rights reserved.
//

#import "HXLineChart.h"
#import "HXLineLabel.h"
#import "HXPointButton.h"

#define HXLineLabelWidth 30
#define HXLineLabelHeight 10

@interface HXLineChart()

@property (nonatomic, strong) NSMutableArray<HXLineLabel *> *yLabelArr;    /**< 显示纵坐标label的数组 */

@property (nonatomic, strong) NSMutableArray<HXLineLabel *> *xLabelArr;    /**< 显示横坐标label的数组 */

@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *horizontalLayers; /**< 横向的线 */

@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *verticalLayers;   /**< 纵向的线 */

@property (nonatomic, strong) NSMutableArray<NSMutableArray<HXPointButton *> *> *pointButtons;    /**< 点的集合 */

@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *valuesLayers;     /**< 划线的layers */

@property (nonatomic, weak) UIButton *popButton;                                /**< popButton */

@end

@implementation HXLineChart

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

/**
 *  初始化操作
 */
- (void)setup {
    // 创建一个弹出框
    UIButton *popButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [popButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    popButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.popButton = popButton;
    [self addSubview:popButton];
    self.popButton.frame = CGRectMake(-50, -50, 35, 30);
    
    self.showLastPopBtn = YES;
    self.canClickButton = YES;

}

#pragma mark - 懒加载
- (NSMutableArray<HXLineLabel *> *)yLabelArr {
    if (!_yLabelArr) {
        _yLabelArr = [[NSMutableArray alloc] init];
    }
    return _yLabelArr;
}

- (NSMutableArray<HXLineLabel *> *)xLabelArr {
    if (!_xLabelArr) {
        _xLabelArr = [[NSMutableArray alloc] init];
    }
    return _xLabelArr;
}

- (NSMutableArray<CAShapeLayer *> *)horizontalLayers {
    if (!_horizontalLayers) {
        _horizontalLayers = [[NSMutableArray alloc] init];
    }
    return _horizontalLayers;
}

- (NSMutableArray<CAShapeLayer *> *)verticalLayers {
    if (!_verticalLayers) {
        _verticalLayers = [[NSMutableArray alloc] init];
    }
    return _verticalLayers;
}

- (NSMutableArray<NSMutableArray<HXPointButton *> *> *)pointButtons {
    if (!_pointButtons) {
        _pointButtons = [[NSMutableArray alloc] init];
    }
    return _pointButtons;
}

- (NSMutableArray<CAShapeLayer *> *)valuesLayers {
    if (!_valuesLayers) {
        _valuesLayers = [[NSMutableArray alloc] init];
    }
    return _valuesLayers;
}

#pragma 重写set方法
/**
 *  重写yCoordinates的set方法, 并创建y轴的label
 *
 */
- (void)setYCoordinates:(NSArray<NSString *> *)yCoordinates {
    _yCoordinates = yCoordinates;
    
    for (NSUInteger i = 0; i < yCoordinates.count; i++) {
        HXLineLabel *label = [[HXLineLabel alloc] init];
        [self addSubview:label];
        label.text = yCoordinates[i];
        [self.yLabelArr addObject:label];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [self.layer insertSublayer:shapeLayer atIndex:0];
        [self.horizontalLayers addObject:shapeLayer];
    }
}

/**
 *  重写xCoordinates的set方法, 并创建x轴的label
 *
 */
- (void)setXCoordinates:(NSArray<NSString *> *)xCoordinates {
    
    NSMutableArray *xCoors = [[NSMutableArray alloc] initWithArray:xCoordinates];
    [xCoors addObject:@""];
    xCoordinates = xCoors;
    
    _xCoordinates = xCoordinates;
    
    for (NSUInteger i = 0; i < xCoordinates.count; i++) {
        HXLineLabel *label = [[HXLineLabel alloc] init];
        [self addSubview:label];
        label.text = xCoordinates[i];
        [self.xLabelArr addObject:label];
    }
    
    for (NSUInteger i = 0; i < xCoordinates.count + 1; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [self.layer insertSublayer:shapeLayer atIndex:0];
        [self.verticalLayers addObject:shapeLayer];
    }
    
}

/**
 *  重写pointValues的set方法, 并创建小圆点以及线段layer
 *
 */
- (void)setPointValues:(NSArray<NSArray *> *)pointValues {
    _pointValues = pointValues;
    
    if (pointValues.count == 0) return;
    
    for (NSUInteger i = 0; i < pointValues.count; i++) {
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.lineWidth = 1.5;
        layer.lineCap = kCALineCapRound;
        layer.lineJoin = kCALineJoinBevel;
//        layer.fillColor = [UIColor clearColor].CGColor;
        UIColor *color;
        if (i <= self.colors.count - 1) {
            color = self.colors[i];
        } else {
            color = [UIColor colorWithRed:239 / 255.0f green:83 / 255.0f blue:68 / 255.0f alpha:1];
        }
        layer.strokeColor = color.CGColor;
        layer.strokeEnd   = 0.0;
        [self.layer insertSublayer:layer atIndex:0];
        [self.valuesLayers addObject:layer];
        
        NSArray<NSString *> *values = pointValues[i];
        NSMutableArray *buttonArr = [[NSMutableArray alloc] init];
        for (NSUInteger j = 0; j < values.count; j++) {
            NSString *value = values[j];
            HXPointButton *button = [HXPointButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor whiteColor];
            NSString *newValue = [NSString stringWithFormat:@"%@-%ld", value, i];
            [button setTitle:newValue forState:UIControlStateNormal];
            [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            button.clipsToBounds = YES;
            button.layer.borderColor = color.CGColor;
            button.layer.borderWidth = 1;
            [self insertSubview:button belowSubview:self.popButton];
            [buttonArr addObject:button];
        }
        [self.pointButtons addObject:buttonArr];
    }
}

#pragma mark - 配置坐标
/**
 *  配置y轴坐标的label
 */
- (void)configYCoordinates {
    CGFloat yAxisHeight = self.frame.size.height - 3 * HXLineLabelHeight;    // y轴的高度
    CGFloat yGridHeight = yAxisHeight / (self.yLabelArr.count - 1);          // y轴每个格子的高度
    CGFloat x = 0.0;                                                         // label的x
    CGFloat y = 0.0;                                                         // label的y
    
    for (NSUInteger i = 0; i < self.yLabelArr.count; i++) {
        // 计算label的frame
        HXLineLabel *label = self.yLabelArr[i];
        y  = self.frame.size.height - (2 * HXLineLabelHeight + i * yGridHeight);
        label.frame = CGRectMake(x, y, HXLineLabelWidth, HXLineLabelHeight);
        
        // 画横线
        CGPoint startPoint = CGPointMake(HXLineLabelWidth, HXLineLabelHeight / 2 * 3 + i * yGridHeight);
        
        CGPoint endPoint;
        if (self.showYLine) {  // 是否显示横线
            endPoint = CGPointMake(self.frame.size.width, HXLineLabelHeight / 2 * 3 + i * yGridHeight);
        } else {
            endPoint = CGPointMake(HXLineLabelWidth + 5, HXLineLabelHeight / 2 * 3 + i * yGridHeight);
        }
        
        CAShapeLayer *layer = self.horizontalLayers[i];
    
        layer.lineWidth = 1;
        if (i == self.yLabelArr.count - 1) {
            endPoint = CGPointMake(self.frame.size.width, HXLineLabelHeight / 2 * 3 + i * yGridHeight);
            layer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.4] CGColor];
            
        } else {
            layer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
        }
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:startPoint];
        [path addLineToPoint:endPoint];
        [path closePath];
    
        layer.path = path.CGPath;
        layer.fillColor = [[UIColor whiteColor] CGColor];
    }
}

/**
 *  配置x轴坐标的label
 */
- (void)configXCoordinates {
    CGFloat xAxisWidth = self.frame.size.width - HXLineLabelWidth;           // x轴的宽度
    CGFloat xGridWidth = xAxisWidth / self.xLabelArr.count;                  // x轴每个格子的宽度
    CGFloat x = 0.0;                                                         // label的x
    CGFloat y = self.frame.size.height - HXLineLabelHeight;                  // label的y
    
    for (NSUInteger i = 0; i < self.xLabelArr.count; i++) {
        // 计算label的frame
        HXLineLabel *label = self.xLabelArr[i];
        x  = HXLineLabelWidth + (i + 0.5) * xGridWidth;
        label.frame = CGRectMake(x, y, xGridWidth, HXLineLabelHeight);
    }
    
    // 画纵线
    for (NSUInteger i = 0; i < self.verticalLayers.count; i++) {

        CGPoint startPoint = CGPointMake(HXLineLabelWidth + i * xGridWidth, self.frame.size.height - HXLineLabelHeight / 2 * 3);
        CGPoint endPoint;
        if (self.showXLine) {    // 判断是否显示竖线
            endPoint = CGPointMake(HXLineLabelWidth + i * xGridWidth, HXLineLabelHeight * 3 / 2);
        } else {
            endPoint = CGPointMake(HXLineLabelWidth + i * xGridWidth, self.frame.size.height - HXLineLabelHeight * 3 / 2 - 5);
        }

        CAShapeLayer *layer = self.verticalLayers[i];
        layer.lineWidth = 1;
        if (i == 0) {
            endPoint = CGPointMake(HXLineLabelWidth + i * xGridWidth, HXLineLabelHeight * 3 / 2);
            layer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.4] CGColor];
        } else {
            layer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
        }
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:startPoint];
        [path addLineToPoint:endPoint];
        [path closePath];
        layer.path = path.CGPath;
        
        layer.fillColor = [[UIColor whiteColor] CGColor];
    }
}

/**
 *  设置小圆点的frame, 并用线连接起来
 */
- (void)configPoints {
    
    if (self.pointButtons.count == 0) return;
    
    CGFloat widthAndHeight = 6;
    CGFloat centerX = 0.0;
    CGFloat centerY = 0.0;
    
    CGFloat minValue = self.yCoordinates.firstObject.floatValue;           // 最小纵坐标
    CGFloat maxValue = self.yCoordinates.lastObject.floatValue;            // 最大纵坐标
    CGFloat minusValue = maxValue - minValue;                              // 最大和最小纵坐标的差
    CGFloat yAxisHeight = self.frame.size.height - 3 * HXLineLabelHeight;  // y轴的高度
    
    for (NSUInteger i = 0; i < self.pointButtons.count; i++) {
        NSMutableArray<HXPointButton *> *buttonArr = self.pointButtons[i];
        CAShapeLayer *layer = self.valuesLayers[i];
        UIBezierPath *path = [UIBezierPath bezierPath];
        for (NSUInteger j = 0; j < buttonArr.count; j++) {
            if (j > self.xLabelArr.count - 1) return;               // 如果点多于横坐标的坐标数, 则剔除
            
            HXPointButton *button = buttonArr[j];
            CGFloat value = [button titleForState:UIControlStateNormal].floatValue;
            
            if ((value < minValue) || (value > maxValue)) return;   // 如果超出坐标的点剔除
            
            centerY = (maxValue - value) /minusValue * yAxisHeight + HXLineLabelHeight / 2 * 3;
            centerX = self.xLabelArr[j].center.x;
            
            button.frame = CGRectMake(0, 0, widthAndHeight, widthAndHeight);
            button.center = CGPointMake(centerX, centerY);
            button.layer.cornerRadius = widthAndHeight / 2;
            
            CGPoint point = CGPointMake(centerX, centerY);
            if (j == 0) {
                [path moveToPoint:point];
            } if (j == self.xLabelArr.count - 1) {
                [path addLineToPoint:point];
            }else {
                [path addLineToPoint:point];
                [path moveToPoint:point];
            }
            
            if (self.showLastPopBtn) {    // 根据属性判断是否显示最后一个的弹出框
                // 显示最后一个值得弹出框
                if ((i == 0) && (j == buttonArr.count - 1)) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.xLabelArr.count + 1) * 0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self pop:button];
                    });
                }
            }
            
        }
        
        layer.path = path.CGPath;
        
        // 做动画
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = self.xLabelArr.count * 0.2;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [layer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        layer.strokeEnd = 1.0;
        
        
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self configYCoordinates];
    
    [self configXCoordinates];
    
    [self configPoints];

}

#pragma mark - 按钮点击
/**
 *  点击小原点按钮弹出的框, 显示值
 *
 *  @param button 所点击的小圆按钮
 */
- (void)pop:(UIButton *)button {
    
    if (!self.canClickButton) return;    // 根据是否可以点击属性设置小圆点按钮可否点击
    
    NSArray<NSString *> *tilteArr = [[button titleForState:UIControlStateNormal] componentsSeparatedByString:@"-"];
    NSString *value = tilteArr[0];
    NSUInteger i = tilteArr[1].integerValue;
    
    NSString *imageName;
    if (i < self.imageNames.count) {
        imageName = self.imageNames[i];
    }else {
        NSString *strBundle = [[NSBundle mainBundle] pathForResource:@"HXChartBundle" ofType:@"bundle"];
        imageName = [[NSBundle bundleWithPath:strBundle] pathForResource:@"pop" ofType:@"png" inDirectory:@"images"];
    }
    
    [self.popButton setTitle:value forState:UIControlStateNormal];
    self.popButton.center = CGPointMake(button.center.x - 6, button.center.y - self.popButton.bounds.size.height / 2 - 2);
    [self.popButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

@end
