//
//  WBABand.h
//  Bands
//
//  Created by ryu on 2014/10/10.
//  Copyright (c) 2014年 ryu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WBATouringStatusOnTour,
    WBATouringStatusOffTour,
    WBATouringStatusDisbanded,
} WBATouringStatus;

@interface WBABand : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, assign) int rating;
@property (nonatomic, assign) WBATouringStatus touringStatus;
@property (nonatomic, assign) BOOL haveSeenLive;

@end
