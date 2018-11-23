//
//  FastRouteErrorViewController.m
//  FasterStoryboardRoute
//
//  Created by lsr on 2018/11/23.
//  Copyright © 2018 Lengshengren. All rights reserved.
//

#import "FastRouteErrorViewController.h"
#define kRGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ssRGBHexAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

@interface FastRouteErrorViewController ()
@property (nonatomic, strong) UIImageView *errorImageView;
@property (nonatomic, strong) UILabel *errorTipLabel;
@property (nonatomic, strong) UIButton *checkVersionButton;
@end


@implementation FastRouteErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRGBHex(0xF8F8F8);
    [self.view addSubview:self.errorImageView];
    [self.view addSubview:self.errorTipLabel];
    if (self.appIDString.length > 0) {
        [self.view addSubview:self.checkVersionButton];
    }
  
    // Do any additional setup after loading the view.
}

- (UIImageView *)errorImageView {
    if (!_errorImageView) {
        _errorImageView = [[UIImageView alloc] init];
        _errorImageView.frame = CGRectMake(self.view.frame.size.width / 2 - 75 , self.view.frame.size.height / 2 - 160, 150, 150);
        if (self.errorImage) {
            _errorImageView.image = self.errorImage;
        } else {
            _errorImageView.image = [UIImage imageNamed:@"errorImage.png"];
        }
     
    }
    return _errorImageView;
}

- (UILabel *)errorTipLabel {
    if (!_errorTipLabel) {
        _errorTipLabel = [[UILabel alloc] init];
        _errorTipLabel.frame =  CGRectMake(15,self.errorImageView.frame.origin.y + 185 ,self.view.frame.size.width - 30 ,20);
        _errorTipLabel.text = self.errorMessage ?: @"该功能不存在,请检查是否是最新版本!";
        _errorTipLabel.textColor = kRGBHex(0x333333);
        _errorTipLabel.textAlignment = NSTextAlignmentCenter;
        _errorTipLabel.font = [UIFont systemFontOfSize:16];
    }
    return _errorTipLabel;
}

- (UIButton *)checkVersionButton {
    if (!_checkVersionButton) {
        _checkVersionButton = [[UIButton alloc] init];
        _checkVersionButton.frame = CGRectMake(self.view.frame.size.width / 2 - 90, self.errorTipLabel.frame.origin.y + 40 , 180, 44);
        [_checkVersionButton addTarget:self action:@selector(checkVersionButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_checkVersionButton setTitle:@"开始检测更新" forState:UIControlStateNormal];
        _checkVersionButton.backgroundColor = kRGBHex(0xFA6469);
    }
    return _checkVersionButton;
}

- (void)checkVersionButtonAction {
    
    NSString *urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",self.appIDString]; //更换id即可
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
        
    }];
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
