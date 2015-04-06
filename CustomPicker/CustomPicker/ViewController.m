//
//  ViewController.m
//  CustomPicker
//
//  Created by Vols on 15/4/6.
//  Copyright (c) 2015年 Vols. All rights reserved.
//

#import "ViewController.h"
#import "VPickerView.h"

@interface ViewController ()<VPickViewDelegate>

@property(nonatomic,strong)VPickerView *pickerView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)click:(id)sender {
    
    _pickerView = [[VPickerView alloc] initPickviewWithArray:@[@"2", @"3", @"4"] isHaveNavControler:NO];

    _pickerView.delegate = self;

    [_pickerView show];
}


-(void)toobarDonBtnHaveClick:(VPickerView *)pickView result:(NSString *)result{
    NSLog(@"result:%@", result);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
