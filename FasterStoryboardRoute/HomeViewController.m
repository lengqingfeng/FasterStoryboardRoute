//
//  HomeViewController.m
//  FasterStoryboardRoute
//
//  Created by lengshengren on 2018/3/4.
//  Copyright © 2018年 Lengshengren. All rights reserved.
//

#import "HomeViewController.h"
#import "FastRoute.h"
@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *jumpButton;

@end

@implementation HomeViewController

- (IBAction)popAction:(id)sender {
    __weak typeof(self)weakSelf = self;
    [FastRoute openURLString:@"faster:/me/detail" params:@{} completion:^(id result) {
        NSDictionary *data = result;
        NSString *titleString = [data objectForKey:@"title"];
        [weakSelf.jumpButton setTitle:titleString forState:UIControlStateNormal];
    }];
   // [FastRoute popToRouteViewControlerWithClassName:@"ViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    [FastRoute callBackWithURLString:@"faster://home/detail" params:@{@"name":@"helloworld"}];
    NSLog(@"name========%@",self.name);
    NSLog(@"age========%@",self.age);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
