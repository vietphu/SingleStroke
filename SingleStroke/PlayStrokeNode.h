//
//  PlayStrokeNode.h
//  SingleStroke
//
//  Created by Taka Okunishi on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

typedef enum _PlayStrokeNodeColor {
    PlayStrokeNodeColorNormal,
    PlayStrokeNodeColorReady,
    PlayStrokeNodeColorActive,
    PlayStrokeNodeColorStacked,
    PlayStrokeNodeColorSolved,
    PlayStrokeNodeColorActiveAndReady
}PlayStrokeNodeColor;

/*********************************************************************/
/* interface                                                         */
/*********************************************************************/
@interface PlayStrokeNode : CALayer
@property(nonatomic, readonly)NSMutableSet *connectableNodes, *connectedNodes;
@property(nonatomic)PlayStrokeNodeColor color;


- (void)addConnectableNode:(PlayStrokeNode *)node;
- (void)addConnectedNode:(PlayStrokeNode *)node;
- (BOOL)isConnectableWithNode:(PlayStrokeNode *)node;
- (BOOL)isConnectedWithNode:(PlayStrokeNode *)node;
- (void)clearAllConnectable;
- (void)clearAllConnected;

- (BOOL)hasConnectable;
- (BOOL)hasUnconnected;

- (BOOL)isOddNode;//has odd number connectables;

- (void)startFocusEffect;

@end
