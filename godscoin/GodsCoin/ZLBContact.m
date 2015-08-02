//
//  ZLBContact.m
//  GodsCoin
//
//  Created by jimmykim on 15/6/13.
//  Copyright (c) 2015年 cn.edu.hhtc. All rights reserved.
//

#import "ZLBContact.h"

@implementation ZLBContact
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.chose forKey:@"chose"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.chose = [decoder decodeObjectForKey:@"chose"];
        
    }
    return self;
}
@end
