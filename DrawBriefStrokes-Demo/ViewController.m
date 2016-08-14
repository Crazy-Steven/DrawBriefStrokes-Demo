//
//  ViewController.m
//  DrawBriefStrokes-Demo
//
//  Created by 郭艾超 on 16/8/14.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import "ViewController.h"
#import "MyBriefStrokesView.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyBriefStrokesView * vc = [[MyBriefStrokesView alloc]initWithFrame:self.view.bounds];
    vc.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:vc];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
