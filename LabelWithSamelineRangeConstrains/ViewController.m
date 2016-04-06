//
//  ViewController.m
//  LabelWithSamelineRangeConstrains
//
//  Created by Pei Wu on 4/5/16.
//  Copyright © 2016 Pei Wu. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+Extension.h"

@interface ViewController ()

@property (nonatomic, strong, nullable) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.label = [UILabel new];
  self.label.font = [UIFont systemFontOfSize:14];
  self.label.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.label];
  self.label.frame = CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-40);
  self.label.numberOfLines = 0;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.label.text = @"123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789";
  [self.label updateLineBreaksBySameLineRangeConstrains:@[[NSValue valueWithRange:NSMakeRange(34, 10)],
                                                          [NSValue valueWithRange:NSMakeRange(84, 50)],
                                                          [NSValue valueWithRange:NSMakeRange(148, 10)]]
                                     withConstrainWidth:self.label.frame.size.width];
}

@end
