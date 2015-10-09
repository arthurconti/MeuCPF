//
//  Header.h
//  Meu CPF
//
//  Created by Arthur Conti on 25/07/15.
//  Copyright (c) 2015 Arthur Conti. All rights reserved.
//
@interface CPF : NSObject<NSCoding> {
    NSString *name;
    NSString *cpf;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *cpf;

@end
