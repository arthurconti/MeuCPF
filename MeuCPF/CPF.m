//
//  CPF.m
//  Meu CPF
//
//  Created by Arthur Conti on 25/07/15.
//  Copyright (c) 2015 Arthur Conti. All rights reserved.
//
//
//#import <Foundation/Foundation.h>
#import "CPF.h"

@implementation CPF

@synthesize name;
@synthesize cpf;

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.cpf = [decoder decodeObjectForKey:@"cpf"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:name forKey:@"name"];
    [encoder encodeObject:cpf forKey:@"cpf"];
}

@end