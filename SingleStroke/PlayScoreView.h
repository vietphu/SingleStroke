//
//  PlayScoreView.h
//  SingleStroke
//
//  Created by Taka Okunishi on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/*********************************************************************/
/* interface                                                         */
/*********************************************************************/
@interface PlayScoreView : UIView
@property(nonatomic, readonly)CATextLayer *bestTitleLayer, *currentTitleLayer;
@property(nonatomic, readonly)CATextLayer *bestScoreLayer, *currentScoreLayer;
- (void)setBestScore:(NSInteger)socre;
- (void)setCurrentScore:(NSInteger)score;
@end
