//
//  PlayStrokeLineLayer.h
//  SingleStroke
//
//  Created by Taka Okunishi on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

/*********************************************************************/
/* interface                                                         */
/*********************************************************************/
@interface PlayStrokeLineLayer : CALayer
@property(nonatomic, readonly)CGMutablePathRef commitedPath, workingPath;
@property(nonatomic)CGFloat lineWidth;
@property(nonatomic)CGColorRef lineColor;

- (void)clearPath;
- (void)clearCommitedPath;
- (void)addWorkLineWithStartPoint:(CGPoint)startPoint
                         endPoint:(CGPoint)endPoint;
- (void)addCommitLineWithStartPoint:(CGPoint)startPoint
                            endPoint:(CGPoint)endPoint;
@end
