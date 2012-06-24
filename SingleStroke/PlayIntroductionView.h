//
//  PlayIntroductionView.h
//  SingleStroke
//
//  Created by Taka Okunishi on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/*********************************************************************/
/* interface                                                         */
/*********************************************************************/
@interface PlayIntroductionView : UIView
@property(nonatomic, readonly)CALayer *logoBackLayer;
@property(nonatomic, readonly)CATextLayer *logoLayer;
@property(nonatomic, readonly)CATextLayer *descriptionLayer;
@end
