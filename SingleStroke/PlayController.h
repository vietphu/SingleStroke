//
//  PlayController.h
//  SingleStroke
//
//  Created by Taka Okunishi on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayView.h"
#import "PlayFinishView.h"
#import "PlayIntroductionView.h"
#import "PlayTimeupView.h"
#import "GADBannerView.h"
#import <iAd/iAd.h>
/*********************************************************************/
/* interface                                                         */
/*********************************************************************/
@interface PlayController : UIViewController<PlayViewDelgate, PlayTimeProgressBarDelegate, ADBannerViewDelegate, GADBannerViewDelegate> {
    BOOL interactionEnabled, solved;
}
@property(nonatomic, retain, readonly)NSMutableArray *activeNodes;
@property(nonatomic)NSInteger score, bestScore;
@property(nonatomic, retain, readwrite)PlayIntroductionView *introductionView;
@property(nonatomic, retain, readonly)PlayFinishView *finishView;
@property(nonatomic, retain, readwrite)PlayTimeupView *timeupView;
@property(nonatomic, readonly)NSInteger currentLevel;
@property(nonatomic, retain)GADBannerView *admobBanner;
@property(nonatomic, retain)ADBannerView *iAdBanner;
@end


/*********************************************************************/
/* interface (Blocker)                                               */
/*********************************************************************/
@interface PlayController(Blocker)<PlayFinishViewDelegate>
@end


