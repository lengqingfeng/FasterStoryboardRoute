//
//  ViewController.m
//  FasterStoryboardRoute
//
//  Created by lengshengren on 2018/3/4.
//  Copyright © 2018年 Lengshengren. All rights reserved.
//

#import "ViewController.h"
#import "FastRoute.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)openViewController:(id)sender {
    //
    //[FastRoute openContorllerWithIdentifier:@"HomeViewController"
    //                                       params:@{@"name":@"LiLei"}];
    
    //[FastRoute openURLString:@"faster://home/detail?name=LiLei"];
    
    //[FastRoute openURLString:@"faster://home/detail?age=11" params:@{@"name":@"LiLei"}];

    //[FasterRoute openURLString:@"faster:/me/setinfo?name=LiLei"];

    [FastRoute openURLString:@"faster://home/detail" params:nil completion:^(id result) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
