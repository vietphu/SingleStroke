//
//  PlayView.h
//  SingleStroke
//
//  Created by Taka Okunishi on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayStrokeNode.h"
#import "PlayStrokeLineLayer.h"
#import "PlayTimeProgressBar.h"
#import "PlayScoreView.h"

#define NodesPerLine 4

typedef enum _PlayMessage{
    PlayMessageWellDone,
    PlayMessageStacked,
    PlayMessageTimeOut,
    PlayMessageNone,
    PlayMessageStart
}PlayMessage;

@protocol PlayViewDelgate <NSObject>
@optional
- (void)overlayDidDismiss:(UIView *)overlay;
@end

/*********************************************************************/
/* interface                                                         */
/*********************************************************************/
@interface PlayView : UIView {
    NSArray *nodes;
}
@property(nonatomic, assign)id<PlayViewDelgate> delegate;
@property(nonatomic, retain)PlayStrokeLineLayer *modelLayer, *actionLayer;
@property(nonatomic, readonly)PlayTimeProgressBar *progressBar;
@property(nonatomic, readonly)NSArray *nodes;
@property(nonatomic, readonly)CATextLayer *messageLayer, *hurryMessageLayer;
@property(nonatomic, readonly)PlayScoreView *scoreView;

- (PlayStrokeNode *)hitNodeWithPoint:(CGPoint)point;
- (PlayStrokeNode *)hitNodeWithPoint:(CGPoint)point
                              margin:(CGFloat)margin;
- (void)reloadActionLayer;
- (void)reloadModelLayer;
- (void)showMessage:(PlayMessage)message;
- (void)hideMessage;


- (void)presentOverlayWithView:(UIView *)view;
- (void)presentOverlayWithViewFlipFromRight:(UIView *)view;
- (void)dismissOverlay;

- (void)showHurryMessage;
@end
