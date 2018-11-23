//
//  FastRouteErrorViewController.h
//  FasterStoryboardRoute
//
//  Created by lsr on 2018/11/23.
//  Copyright © 2018 Lengshengren. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FastRouteErrorViewController : UIViewController
@property (nonatomic, strong) NSString *appIDString;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, strong) UIImage *errorImage;
@end

NS_ASSUME_NONNULL_END
