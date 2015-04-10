//
//  VPickerView.m
//  CustomPicker
//
//  Created by Vols on 15/4/6.
//  Copyright (c) 2015年 Vols. All rights reserved.
//

#import "VPickerView.h"
typedef NS_ENUM(NSInteger, VPickerType){
    VPickerTypeSingleCols,
    VPickerTypeMutiColsFromArray,
    VPickerTypeMutiColsFromDic,
    VPickerTypeDate
};


#define ZHToobarHeight 40

@interface VPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, copy)    NSString    *plistName;
@property (nonatomic, strong)  NSArray     *dataSource; //picker数据源

@property (nonatomic, assign) VPickerType pickerType;

@property (nonatomic, strong) NSDictionary *levelTwoDic;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, assign) NSDate *defaulDate;

@property (nonatomic, assign)   NSInteger pickeViewHeight;
@property (nonatomic, copy)     NSString *resultString;
@property (nonatomic, assign)   NSUInteger selectedIndex;

@property (nonatomic, strong)   NSMutableArray *componentArray;
@property (nonatomic, strong)   NSMutableArray *dicKeyArray;
@property (nonatomic, copy)     NSMutableArray *state;
@property (nonatomic, copy)     NSMutableArray *city;

@end

@implementation VPickerView

-(NSArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource=[[NSArray alloc] init];
    }
    return _dataSource;
}

-(NSArray *)componentArray{
    if (_componentArray==nil) {
        _componentArray=[[NSMutableArray alloc] init];
    }
    return _componentArray;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpToolBar];
    }
    return self;
}

-(instancetype)initPickviewWithPlistName:(NSString *)plistName{
    self=[super init];
    if (self) {
        _plistName = plistName;
        self.dataSource=[self getPlistArrayByplistName:plistName];
        [self setUpPickView];
        [self setViewFrame];
    }
    return self;
}

-(instancetype)initPickviewWithArray:(NSArray *)array{
    self=[super init];
    if (self) {
        self.dataSource = array;
        [self setArrayClass:array];
        [self setUpPickView];
        [self setViewFrame];
    }
    return self;
}

-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode{
    
    self=[super init];
    if (self) {
        _defaulDate=defaulDate;
        [self setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode];
        [self setViewFrame];
    }
    return self;
}

-(void)remove{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0);
        
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}


-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat viewH = _pickeViewHeight + ZHToobarHeight;
        CGFloat viewY = [UIScreen mainScreen].bounds.size.height - viewH;
        CGFloat viewW = [UIScreen mainScreen].bounds.size.width;
        
        self.frame = CGRectMake(0, viewY, viewW, viewH);
    }];
}


#pragma mark - actions

-(void)doneClick{
    
    if (_pickerView) {
        if (_resultString == nil) {
            if (self.pickerType == VPickerTypeMutiColsFromArray) {
                _resultString=@"";
                for (int i=0; i<_dataSource.count;i++) {
                    _resultString=[NSString stringWithFormat:@"%@-%@",_resultString, _dataSource[i][0]];
                }
                
            } else if (self.pickerType == VPickerTypeSingleCols){
                _resultString = [NSString stringWithFormat:@"%@",_dataSource[0]];
                
            }else if(self.pickerType == VPickerTypeMutiColsFromDic){
                
                if (_state==nil) {
                    _state =_dicKeyArray[0][0];
                    NSDictionary *dicValueDic=_dataSource[0];
                    _city = [dicValueDic allValues][0][0];
                }
                if (_city==nil){
                    NSInteger cIndex = [_pickerView selectedRowInComponent:0];
                    NSDictionary *dicValueDic = _dataSource[cIndex];
                    _city=[dicValueDic allValues][0][0];
                }
                
                _resultString=[NSString stringWithFormat:@"%@%@",_state,_city];
            }
        }
    }
    else if (_datePicker) {
        _resultString=[NSString stringWithFormat:@"%@",_datePicker.date];
    }

    
//    if (_pickerView) {
//        
//        if (_resultString) {
//            
//        }else{
//            if (_isLevelString) {
//                _resultString = [NSString stringWithFormat:@"%@",_plistArray[0]];
//            }else if (_isLevelArray){
//                _resultString=@"";
//                for (int i=0; i<_plistArray.count;i++) {
//                    _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
//                }
//            }else if (_isLevelDic){
//                
//                if (_state==nil) {
//                    _state =_dicKeyArray[0][0];
//                    NSDictionary *dicValueDic=_plistArray[0];
//                    _city=[dicValueDic allValues][0][0];
//                }
//                if (_city==nil){
//                    NSInteger cIndex = [_pickerView selectedRowInComponent:0];
//                    NSDictionary *dicValueDic=_plistArray[cIndex];
//                    _city=[dicValueDic allValues][0][0];
//                    
//                }
//                _resultString=[NSString stringWithFormat:@"%@%@",_state,_city];
//            }
//        }
//    }
//    else if (_datePicker) {
//        _resultString=[NSString stringWithFormat:@"%@",_datePicker.date];
//    }
//    
    
    if ([self.delegate respondsToSelector:@selector(pickerView:resultSelectedRow:)]) {
        [self.delegate pickerView:self resultSelectedRow:[_pickerView selectedRowInComponent:0]];
    }
    
    if ([self.delegate respondsToSelector:@selector(pickerView:resultString:)]) {
        
        if ([_resultString hasPrefix:@"-"]) {
            _resultString = [_resultString substringFromIndex:1];
        }
        
        [self.delegate pickerView:self resultString:_resultString];
    }
    
    
    [self remove];
}


#pragma mark piackView 数据源方法

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    NSInteger component;
    if (self.pickerType == VPickerTypeMutiColsFromArray) {
        component = _dataSource.count;
        
    } else if (self.pickerType == VPickerTypeSingleCols){
        component = 1;
        
    }else if(self.pickerType == VPickerTypeMutiColsFromDic){
        component = [_levelTwoDic allKeys].count * 2;
    }
    
    return component;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *rowArray = [[NSArray alloc] init];
    
    if (self.pickerType == VPickerTypeMutiColsFromArray) {
        rowArray = _dataSource[component];
        
    } else if (self.pickerType == VPickerTypeSingleCols){
        rowArray = _dataSource;
        
    }else if(self.pickerType == VPickerTypeMutiColsFromDic){
        
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_dataSource[pIndex];
        for (id dicValue in [dic allValues]) {
            if ([dicValue isKindOfClass:[NSArray class]]) {
                if (component%2==1) {
                    rowArray=dicValue;
                }else{
                    rowArray=_dataSource;
                }
            }
        }
    }
    return rowArray.count;
}

#pragma mark UIPickerViewdelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *rowTitle = nil;
    
    if (self.pickerType == VPickerTypeMutiColsFromArray) {
        
        rowTitle = _dataSource[component][row];
        
    } else if (self.pickerType == VPickerTypeSingleCols){
        
        rowTitle=_dataSource[row];
        
    }else if(self.pickerType == VPickerTypeMutiColsFromDic){
        
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_dataSource[pIndex];
        
        if(component%2==0){
            rowTitle=_dicKeyArray[row][component];
        }
        
        for (id aa in [dic allValues]) {
            if ([aa isKindOfClass:[NSArray class]]&&component%2==1){
                NSArray *bb=aa;
                if (bb.count>row) {
                    rowTitle=aa[row];
                }
            }
        }
    }
    
    return rowTitle;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (self.pickerType == VPickerTypeMutiColsFromDic && component%2 == 0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    
    if (self.pickerType == VPickerTypeSingleCols) {
        
        _resultString = _dataSource[row];

    }else if (self.pickerType == VPickerTypeMutiColsFromArray) {
        
        _resultString = @"";
        
        if (![self.componentArray containsObject:@(component)]) {
            [self.componentArray addObject:@(component)];
        }
        
        for (int i=0; i<_dataSource.count;i++) {
            if ([self.componentArray containsObject:@(i)]) {
                NSInteger cIndex = [pickerView selectedRowInComponent:i];

                    _resultString=[NSString stringWithFormat:@"%@-%@",_resultString, _dataSource[i][cIndex]];
                
            }else{
    
                    _resultString = [NSString stringWithFormat:@"%@-%@",_resultString, _dataSource[i][0]];
                
            }
        }
    }else if(self.pickerType == VPickerTypeMutiColsFromDic){
        if (component==0) {
            _state =_dicKeyArray[row][0];
        }else{
            NSInteger cIndex = [pickerView selectedRowInComponent:0];
            NSDictionary *dicValueDic=_dataSource[cIndex];
            NSArray *dicValueArray=[dicValueDic allValues][0];
            if (dicValueArray.count>row) {
                _city =dicValueArray[row];
            }
        }
    }
}


#pragma mark - helper

-(NSArray *)getPlistArrayByplistName:(NSString *)plistName{
    
    NSString *path= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray * array=[[NSArray alloc] initWithContentsOfFile:path];
    [self setArrayClass:array];
    return array;
}


-(void)setArrayClass:(NSArray *)array{
    
    _dicKeyArray=[[NSMutableArray alloc] init];
    
    for (id item in array) {
        
        if ([item isKindOfClass:[NSArray class]]) {
            
            self.pickerType = VPickerTypeMutiColsFromArray;
            
        }else if ([item isKindOfClass:[NSString class]]) {
            
            self.pickerType = VPickerTypeSingleCols;
            
        }else if ([item isKindOfClass:[NSDictionary class]]) {
            
            self.pickerType = VPickerTypeMutiColsFromDic;
            
            _levelTwoDic = item;
            [_dicKeyArray addObject:[_levelTwoDic allKeys]];
        }
    }
}

-(void)setViewFrame{
    
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height,  [UIScreen mainScreen].bounds.size.width, 0);
}

-(void)setUpPickView{
    UIPickerView *pickView=[[UIPickerView alloc] init];
    pickView.backgroundColor=[UIColor lightGrayColor];
    _pickerView = pickView;
    pickView.delegate = self;
    pickView.dataSource = self;
    pickView.frame=CGRectMake(0, ZHToobarHeight, pickView.frame.size.width, pickView.frame.size.height);
    _pickeViewHeight = pickView.frame.size.height;
    
    _selectedIndex = 0;
    
    [self addSubview:pickView];
}

-(void)setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode{
    UIDatePicker *datePicker=[[UIDatePicker alloc] init];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePickerMode = datePickerMode;
    datePicker.backgroundColor=[UIColor lightGrayColor];
    if (_defaulDate) {
        [datePicker setDate:_defaulDate];
    }
    _datePicker=datePicker;
    datePicker.frame=CGRectMake(0, ZHToobarHeight, datePicker.frame.size.width, datePicker.frame.size.height);
    _pickeViewHeight=datePicker.frame.size.height;
    [self addSubview:datePicker];
}

#pragma mark - UIToolBar

-(void)setUpToolBar{
    _toolbar=[self setToolbarStyle];
    [self setToolbarWithPickViewFrame];
    [self addSubview:_toolbar];
}

-(void)setToolbarWithPickViewFrame{
    _toolbar.frame=CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, ZHToobarHeight);
}

-(UIToolbar *)setToolbarStyle{
    UIToolbar *toolbar=[[UIToolbar alloc] init];
    
    UIBarButtonItem *lefttem=[[UIBarButtonItem alloc] initWithTitle:@" 取消" style:UIBarButtonItemStylePlain target:self action:@selector(remove)];
    
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"确定 " style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    toolbar.items=@[lefttem,centerSpace,right];
    
    return toolbar;
}




/**
 *  设置PickView的颜色
 */
-(void)setPickViewColer:(UIColor *)color{
    _pickerView.backgroundColor = color;
}

/**
 *  设置toobar的文字颜色
 */
-(void)setTintColor:(UIColor *)color{
    
    _toolbar.tintColor = color;
}

/**
 *  设置toobar的背景颜色
 */
-(void)setToolbarTintColor:(UIColor *)color{
    
    _toolbar.barTintColor=color;
}

-(void)dealloc{
    
    //NSLog(@"销毁了");
}

@end
