//
//  PlayProgressView.h
//  SingleStroke
//
//  Created by Taka Okunishi on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayTimeProgressBarDelegate <NSObject>

- (void)timeDidOut;
- (void)timeWillShort;
@end


/*********************************************************************/
/* interface                                                         */
/*********************************************************************/
@interface PlayTimeProgressBar : UIView;
@property(nonatomic, assign)id<PlayTimeProgressBarDelegate> delegate;
@property(nonatomic, readonly)CALayer *shrinkLayer, *shrinkDisplayLayer;
@property(nonatomic)BOOL paused;
@property(nonatomic)CGFloat duration;
@property(nonatomic, retain)NSTimer *hurryTimer;
- (void)start;
- (void)pause;
-(void)resume;
@end
