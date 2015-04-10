//
//  VPickerView.h
//  CustomPicker
//
//  Created by Vols on 15/4/6.
//  Copyright (c) 2015年 Vols. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VPickerView;

@protocol VPickViewDelegate <NSObject>

@optional

-(void)pickerView:(VPickerView *)pickView resultSelectedRow:(NSUInteger)row;
-(void)pickerView:(VPickerView *)pickView resultString:(NSString *)resultString;


@end


@interface VPickerView : UIView

@property(nonatomic,weak) id<VPickViewDelegate> delegate;

/**
 *  通过plistName添加一个pickView
 *
 *  @param plistName          plist文件的名字
 
 *  @param isHaveNavControler 是否在NavControler之内
 *
 *  @return 带有toolbar的pickview
 */

-(instancetype)initPickviewWithPlistName:(NSString *)plistName;


/**
 *  通过plistName添加一个pickView
 *
 *  @param array              需要显示的数组
 *  @param isHaveNavControler 是否在NavControler之内
 *
 *  @return 带有toolbar的pickview
 */
-(instancetype)initPickviewWithArray:(NSArray *)array;


/**
 *  通过时间创建一个DatePicker
 *
 *  @param date               默认选中时间
 *  @param isHaveNavControler是否在NavControler之内
 *
 *  @return 带有toolbar的datePicker
 */
-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode;

/**
 *   移除本控件
 */
-(void)remove;
/**
 *  显示本控件
 */
-(void)show;
/**
 *  设置PickView的颜色
 */
-(void)setPickViewColer:(UIColor *)color;
/**
 *  设置toobar的文字颜色
 */
-(void)setTintColor:(UIColor *)color;
/**
 *  设置toobar的背景颜色
 */
-(void)setToolbarTintColor:(UIColor *)color;


@end
