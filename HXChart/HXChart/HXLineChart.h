//
//  HXLineView.h
//  HXChart
//
//  Created by 佘红响 on 16/7/9.
//  Copyright © 2016年 she. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXLineChart : UIView

@property (strong, nonatomic) NSArray<NSString *> *yCoordinates;  /**< 纵坐标数组 */
@property (strong, nonatomic) NSArray<NSString *> *xCoordinates;  /**< 横坐标数组 */
@property (strong, nonatomic) NSArray<NSArray *> *pointValues;    /**< 坐标值数组 */
@property (strong, nonatomic) NSArray<UIColor *> *colors;         /**< 颜色数组 */
@property (strong, nonatomic) NSArray<NSString *> *imageNames;    /**< 图片名称数组 */

@property (nonatomic, assign) BOOL showXLine;                     /**< 是否显示网格的竖线 */

@property (nonatomic, assign) BOOL showYLine;                     /**< 是否显示网格的横线 */

@property (nonatomic, assign) BOOL canClickButton;                /**< 小圆点按钮是否可点击 */

@property (nonatomic, assign) BOOL showLastPopBtn;                /**< 是否显示最后一个值的弹出框 */

@end
