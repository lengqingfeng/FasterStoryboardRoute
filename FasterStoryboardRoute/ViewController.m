//
//  ViewController.m
//  FasterStoryboardRoute
//
//  Created by lengshengren on 2018/3/4.
//  Copyright © 2018年 Lengshengren. All rights reserved.
//

#import "ViewController.h"
#import "FasterRoute.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)openViewController:(id)sender {
//    [FasterRoute openContorllerWithIdentifier:@"HomeViewController"
//                                       source:self
//                                       params:@{@"name":@"LiLei"}];
    
    //[FasterRoute openUrlString:@"faster://home/detail?name=LiLei"];
    [FasterRoute openUrlString:@"faster:/me/setinfo?name=LiLei"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
