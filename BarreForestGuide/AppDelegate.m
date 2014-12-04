//
//  AppDelegate.m
//  BarreForestGuide
//
//  Created by Craig B. Agricola on 10/20/14.
//  Copyright (c) 2014 Town of Barre. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "MapViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"GOOGLE_MAPS_API_KEY"];

    if ([[UIApplication sharedApplication]
           respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
      [[UIApplication sharedApplication]
         registerUserNotificationSettings: [UIUserNotificationSettings
                                              settingsForTypes:(UIUserNotificationTypeSound |
                                                                UIUserNotificationTypeAlert |
                                                                UIUserNotificationTypeBadge)
                                                    categories:nil]];
      [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
      [[UIApplication sharedApplication]
        registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                            UIUserNotificationTypeSound |
                                            UIUserNotificationTypeAlert)];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    //get and format the device Token
    NSString *newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    //get and format the device unique ID
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    uniqueIdentifier = [uniqueIdentifier stringByReplacingOccurrencesOfString:@"-" withString:@""];

    //set request data
    NSString *url = [NSString stringWithFormat:@"http://www.uvm.edu/~kgauger/BarreTownForest/updateToken.php"];
    NSString *post = [NSString stringWithFormat:@"&device_id=%@&device_token=%@",uniqueIdentifier,newToken];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    //Create the request.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    //Set the HTTPBody of the urlrequest with postData.
    [request setHTTPBody:postData];

    //Create URLConnection object. Initialize it with the URLRequest.
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];

    //Remove old badge
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"Failed to get token, error: %@", error);
}

//Receive the data which we get using post method.

//receive the error report in case of connection is not made to server.

//process the data after connection has made successfully.

#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // Initialize _responseData, NSMutableData object, defined in AppDelegate, to append data in the didReceiveData method
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Request complete and data received, Decode response data
    NSString *responsestring = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    // Print Response to Console
    NSLog(@"responseData: %@", responsestring);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason! Check the error var.
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        NSString *cancelTitle = @"Close";
        NSString *showTitle = @"Show";
        NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Notification"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelTitle
                                                  otherButtonTitles:showTitle, nil];
        [alertView show];
    } else {
        //Do stuff that you would do if the application was not active
    }
}

@end

/* vim: set ai si sw=2 ts=80 ru: */
