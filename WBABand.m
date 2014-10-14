//
//  WBABand.m
//  Bands
//
//  Created by ryu on 2014/10/10.
//  Copyright (c) 2014年 ryu. All rights reserved.
//


#import "WBABand.h"

static NSString *nameKey = @"BANameKey";
static NSString *notesKey = @"BANotesKey";
static NSString *ratingKey = @"BARatingKey";
static NSString *tourStatusKey = @"BATourStatusKey";
static NSString *haveSeenLiveKey = @"BAHaveSeenLiveKey";

@implementation WBABand

-(id) initWithCoder:(NSCoder*)coder
{
    self = [super init];
    
    self.name = [coder decodeObjectForKey:nameKey];
    self.notes = [coder decodeObjectForKey:notesKey];
    self.rating = [coder decodeIntegerForKey:ratingKey];
    self.touringStatus = [coder decodeIntegerForKey:tourStatusKey];
    self.haveSeenLive = [coder decodeBoolForKey:haveSeenLiveKey];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name forKey:nameKey];
    [coder encodeObject:self.notes forKey:notesKey];
    [coder encodeInteger:self.rating forKey:ratingKey];
    [coder encodeInteger:self.touringStatus forKey:tourStatusKey];
    [coder encodeBool:self.haveSeenLive forKey:haveSeenLiveKey];
}

- (NSComparisonResult)compare:(WBABand *)otherObject
{
    return [self.name compare:otherObject.name];
}
@end
