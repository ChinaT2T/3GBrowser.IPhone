//
//  _GBrowserAppDelegate.h
//  3GBrowser
//
//  Created by apple on 11-8-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class _GBrowserViewController;

@interface _GBrowserAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet _GBrowserViewController *viewController;

@end
