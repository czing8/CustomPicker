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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)click:(id)sender {
    
    _pickerView = [[VPickerView alloc] initPickviewWithArray:@[@"2", @"3", @"4"]];

    _pickerView.delegate = self;

    [_pickerView show];
}

- (void)pickerView:(VPickerView *)pickView resultSelectedRow:(NSUInteger)row{
    NSLog(@"row:%lu", (unsigned long)row);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
