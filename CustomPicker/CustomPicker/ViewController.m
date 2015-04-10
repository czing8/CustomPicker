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

@property (nonatomic, strong) VPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UITextField *txtBirth;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pickerView = [[VPickerView alloc] initPickviewWithArray:@[@"2", @"3", @"4"]];
    _pickerView.delegate = self;
    _txtBirth.inputView = _pickerView;
}

- (IBAction)click:(id)sender {
    
    _pickerView = [[VPickerView alloc] initPickviewWithArray:@[@"2", @"3", @"4"]];

    _pickerView.delegate = self;
    
    [_pickerView show];
}


- (IBAction)mutiPickerClick:(id)sender {

    
    _pickerView = [[VPickerView alloc] initPickviewWithArray:@[@[@"1",@"小明",@"aa"],@[@"2",@"大黄",@"bb"]]];
    _pickerView.delegate = self;
    
    [_pickerView show];
}

- (IBAction)mutiPicker2Click:(id)sender {
    if (_pickerView) {
        [_pickerView remove];
    }
}


- (void)pickerView:(VPickerView *)pickView resultSelectedRow:(NSUInteger)row{
    NSLog(@"row:%lu", (unsigned long)row);
}

- (void)pickerView:(VPickerView *)pickView resultString:(NSString *)resultString{
    NSLog(@"resultString:%@", resultString);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
