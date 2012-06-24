//
//  PlayBlockerView.h
//  SingleStroke
//
//  Created by Taka Okunishi on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol PlayFinishViewDelegate <NSObject>

- (void)againButtonDidPress:(UIButton *)againButton;
@end
/*********************************************************************/
/* interface                                                         */
/*********************************************************************/
@interface PlayFinishView : UIView
@property(nonatomic, assign)id<PlayFinishViewDelegate> delegate;
@property(nonatomic, readonly)CATextLayer *scoreLayer;
@property(nonatomic, readonly)UIButton *againButton;
- (void)prepareMessageWithScore:(NSInteger)score;
@end
