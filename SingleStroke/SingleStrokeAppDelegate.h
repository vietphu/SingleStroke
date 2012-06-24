//
//  SingleStrokeAppDelegate.h
//  SingleStroke
//
//  Created by Taka Okunishi on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlayController;
/*********************************************************************/
/* interface                                                         */
/*********************************************************************/
@interface SingleStrokeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PlayController *playController;
}


@end
