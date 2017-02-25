//
//  Person.m
//  FileOperation
//
//  Created by 宋晓光 on 25/02/2017.
//  Copyright © 2017 Light. All rights reserved.
//

#import "Person.h"

@interface Person () <NSCoding>

@end

@implementation Person

//  归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.name forKey:@"name"];
  [aCoder encodeObject:@(self.age) forKey:@"age"];
}

//  解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.age = [[aDecoder decodeObjectForKey:@"age"] integerValue];
  }
  return self;
}

@end
