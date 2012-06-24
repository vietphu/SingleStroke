//
//  PlayIntroductionView.m
//  SingleStroke
//
//  Created by Taka Okunishi on 9/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayIntroductionView.h"
#define LogoTitle @"Single Stroke"
#define DesctiptionText @"connect dots \nin \na single stroke"
#define StartButtonTitle @"start"

/*********************************************************************/
/*  private interface                                                */
/*********************************************************************/
@interface PlayIntroductionView(private)


@end

/*********************************************************************/
/* implementation                                                    */
/*********************************************************************/
@implementation PlayIntroductionView
@synthesize logoLayer, logoBackLayer;
@synthesize descriptionLayer;
- (CATextLayer *)logoLayer {
    if (logoLayer) return logoLayer;
    CATextLayer *layer = [CATextLayer layer];
    [layer setString:LogoTitle];
    [layer setAlignmentMode:kCAAlignmentLeft];
    [layer setFontSize:40];
    layer.font = AppBoldFontName;

    [self.layer addSublayer:layer];
    logoLayer = layer;
    return logoLayer;
}
- (CATextLayer *)descriptionLayer {
    if (descriptionLayer) return descriptionLayer;
    CATextLayer *layer = [CATextLayer layer];
    [layer setString:DesctiptionText];
    [layer setFontSize:22];
    CGColorRef color = [[UIColor grayColor] CGColor];
    [layer setForegroundColor:color];
    [layer setAlignmentMode:kCAAlignmentLeft];
    layer.font = AppFontName;
    [self.layer addSublayer:layer];
    descriptionLayer = layer;
    return descriptionLayer;
}
- (CALayer *)logoBackLayer {
    if (logoBackLayer) return logoBackLayer;
    CALayer *layer = [CALayer layer];

    [self.layer addSublayer:layer];
    logoBackLayer = layer;
    return logoBackLayer;
}
#pragma mark -
- (id)init {
    self = [super init];
    if (self) {
        UIColor *color = [UIColor blackColor];
        [self setBackgroundColor:color];
    }
    return self;
}
- (void)layoutSubviews {
    CGFloat x, y;
    y = 100;
    CGFloat padding = 20;
    CGFloat width = CGRectGetWidth(self.bounds) - padding * 2;
    x = padding;
    [self.logoLayer setFrame:CGRectMake(x, y, width, 40)];
    
    y += 100;
    [self.descriptionLayer setFrame:CGRectMake(x, y, width, 150)];
    
    
}
@end

/*********************************************************************/
/*  private implementation                                           */
/*********************************************************************/
@implementation PlayIntroductionView(private)



@end