//
//  GJDetailViewController.m
//  FasterStoryboardRoute
//
//  Created by lsr on 2018/10/9.
//  Copyright © 2018 Lengshengren. All rights reserved.
//

#import "GJDetailViewController.h"
#import "FastRoute.h"
@interface GJDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputText;

@end

@implementation GJDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)jump:(id)sender {
    
    [FastRoute callBackWithURLString:@"faster:/me/detail" params:@{@"title":self.inputText.text ?:@""}];
    [self.navigationController popViewControllerAnimated:YES];
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
