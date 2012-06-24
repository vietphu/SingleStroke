//
//  PlayScoreView.m
//  SingleStroke
//
//  Created by Taka Okunishi on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayScoreView.h"
#define BestTitleString @"best :"
#define CurrentTitleString @"now :"
#define TitleFontSize 15
#define ScoreFontSize 16
#import "Constants.h"
/*********************************************************************/
/*  private interface                                                */
/*********************************************************************/
@interface PlayScoreView(private)

@end

/*********************************************************************/
/* implementation                                                    */
/*********************************************************************/
@implementation PlayScoreView
#pragma mark -
@synthesize bestTitleLayer, currentTitleLayer;
@synthesize bestScoreLayer, currentScoreLayer;
- (CATextLayer *)bestTitleLayer {
    if (bestTitleLayer) return bestTitleLayer;
    CATextLayer *layer = [CATextLayer layer];
    [layer setFontSize:TitleFontSize];
    [layer setString:BestTitleString];
    layer.font = AppFontName;
    [self.layer addSublayer:layer];
    bestTitleLayer = layer;
    return bestTitleLayer;
}
- (CATextLayer *)currentTitleLayer {
    if (currentTitleLayer) return currentTitleLayer;
    CATextLayer *layer = [CATextLayer layer];
    [layer setFontSize:TitleFontSize];
    [layer setString:CurrentTitleString];
    layer.font = AppFontName;
    [self.layer addSublayer:layer];
    currentTitleLayer = layer;
    return currentTitleLayer;
}
- (CATextLayer *)bestScoreLayer {
    if (bestScoreLayer) return bestScoreLayer;
    CATextLayer *layer = [CATextLayer layer];
    [layer setFontSize:ScoreFontSize];
    [layer setAlignmentMode:kCAAlignmentRight];
    [layer setString:@"0"];
    layer.font = AppFontName;
    [self.layer addSublayer:layer];
    bestScoreLayer = layer;
    return bestScoreLayer;
}
- (CATextLayer *)currentScoreLayer {
    if (currentScoreLayer) return currentScoreLayer;
    CATextLayer *layer = [CATextLayer layer];
    [layer setFontSize:ScoreFontSize];
    [layer setAlignmentMode:kCAAlignmentRight];
    [layer setString:@"0"];
    layer.font = AppFontName;
    [self.layer addSublayer:layer];
    currentScoreLayer = layer;
    return currentScoreLayer;
}

- (void)setBestScore:(NSInteger)score {
    NSString *scoreString = [NSString stringWithFormat:@"%d", score];
    [self.bestScoreLayer setString:scoreString];
}
- (void)setCurrentScore:(NSInteger)score {
    NSString *scoreString = [NSString stringWithFormat:@"%d", score];
    [self.currentScoreLayer setString:scoreString];
}
#pragma mark -
#define Padding 5
- (void)layoutSubviews {
    CGFloat x, y;
    x = Padding, y = Padding;
    static const CGFloat titleWidth = 43, scoreWidth = 30;
    static const CGFloat height = 20;
    [self.bestTitleLayer setFrame:CGRectMake(x, y, titleWidth, height)];
    x += titleWidth;
    [self.bestScoreLayer setFrame:CGRectMake(x, y, scoreWidth, height)];
    x = Padding; y += height;
    [self.currentTitleLayer setFrame:CGRectMake(x, y, titleWidth, height)];
    x += titleWidth;
    [self.currentScoreLayer setFrame:CGRectMake(x, y, scoreWidth, height)];
}
@end

/*********************************************************************/
/*  private implementation                                           */
/*********************************************************************/
@implementation PlayScoreView(private)



@end