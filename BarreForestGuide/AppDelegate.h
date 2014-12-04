//
//  AppDelegate.h
//  BarreForestGuide
//
//  Created by Craig B. Agricola on 10/20/14.
//  Copyright (c) 2014 Town of Barre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
  NSMutableData *_responseData;
}

@property (strong, nonatomic) UIWindow *window;
@property ConfigModel *configModel;

@end


/* vim: set ai si sw=2 ts=80 ru: */
