//
//  FacebookViewController.h
//  BarreForestGuide
//
//  Created by Huyen Lam on 11/24/14.
//  Copyright (c) 2014 Town of Barre. All rights reserved.
//

#ifndef BarreForestGuide_FacebookViewController_h
#define BarreForestGuide_FacebookViewController_h


#endif

#import <UIKit/UIKit.h>
#import "FacebookSDK/FacebookSDK.h"

@interface FacebookViewController : UIViewController <FBFriendPickerDelegate>
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@end

