//
//  ViewController.m
//  FileOperation
//
//  Created by 宋晓光 on 25/02/2017.
//  Copyright © 2017 Light. All rights reserved.
//

#import "ViewController.h"

#import "Person.h"

@interface ViewController ()

@property(nonatomic, strong) NSString *docPath;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  //  获取沙盒路径
  self.docPath = [NSSearchPathForDirectoriesInDomains(
      NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  //  NSString
  [self stringIO];
  //  NSArray
  [self arrayIO];
  //  NSDictionary
  [self dictionaryIO];
  //  NSData
  [self dataIO];
  //  NSFileManager
  [self fileManager];
  //  NSFileHandle
  [self fileHandle];
  //  NSObject
  [self archive];
}

- (void)stringIO {
  //  写
  NSString *string = @"Hello World!";
  NSString *path = [self.docPath stringByAppendingPathComponent:@"string.txt"];
  BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
  if (!isExist) {
    [string writeToFile:path
             atomically:YES
               encoding:NSUTF8StringEncoding
                  error:nil];
  }
  //  读
  isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
  if (isExist) {
    NSString *string = [NSString stringWithContentsOfFile:path
                                                 encoding:NSUTF8StringEncoding
                                                    error:nil];
    NSLog(@"String: %@", string);
  }
}

- (void)arrayIO {
  //  写
  NSArray *array = @[ @"Hello", @" ", @"World", @"!" ];
  NSString *path = [self.docPath stringByAppendingPathComponent:@"array.txt"];
  BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
  if (!isExist) {
    [array writeToFile:path atomically:YES];
  }
  //  读
  isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
  if (isExist) {
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSLog(@"Array: %@", array);
  }
}

- (void)dictionaryIO {
  //  写
  NSDictionary *dictionary = @{ @"key1" : @"Hello ", @"key2" : @"World!" };
  NSString *path =
      [self.docPath stringByAppendingPathComponent:@"dictionary.txt"];
  BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
  if (!isExist) {
    [dictionary writeToFile:path atomically:YES];
  }
  //  读
  isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
  if (isExist) {
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"Dictionary %@", dictionary);
  }
}

- (void)dataIO {
  //  写
  NSData *data = [@"Hello World!" dataUsingEncoding:NSUTF8StringEncoding];
  NSString *path = [self.docPath stringByAppendingPathComponent:@"data.txt"];
  BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
  if (!isExist) {
    [data writeToFile:path atomically:YES];
  }
  //  读
  isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
  if (isExist) {
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSLog(@"Data %@", data);
  }
}

- (void)fileManager {
  //  创建路径
  NSString *dir = [self.docPath stringByAppendingPathComponent:@"dir"];
  BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:dir];
  if (!isExist) {
    [[NSFileManager defaultManager] createDirectoryAtPath:dir
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
  }
  //  创建文件
  NSString *path = [dir stringByAppendingPathComponent:@"file.txt"];
  isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
  if (!isExist) {
    [[NSFileManager defaultManager]
        createFileAtPath:path
                contents:[@"Hello World!"
                             dataUsingEncoding:NSUTF8StringEncoding]
              attributes:nil];
  }
  //  移动文件
  NSString *toPath =
      [self.docPath stringByAppendingPathComponent:@"toFile.txt"];
  if ([[NSFileManager defaultManager] fileExistsAtPath:path] &&
      ![[NSFileManager defaultManager] fileExistsAtPath:toPath]) {
    [[NSFileManager defaultManager] moveItemAtPath:path
                                            toPath:toPath
                                             error:nil];
  }
  //  读取文件
  NSString *string = [NSString stringWithContentsOfFile:toPath
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];
  NSLog(@"File %@", string);
  //  删除文件
  if ([[NSFileManager defaultManager] fileExistsAtPath:toPath]) {
    [[NSFileManager defaultManager] removeItemAtPath:toPath error:nil];
  }
  //  删除路径
  if ([[NSFileManager defaultManager] fileExistsAtPath:dir]) {
    [[NSFileManager defaultManager] removeItemAtPath:dir error:nil];
  }
}

- (void)fileHandle {
  //  追加文件
  NSString *path = [self.docPath stringByAppendingPathComponent:@"string.txt"];
  BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
  if (isExist) {
    NSFileHandle *handle = [NSFileHandle fileHandleForUpdatingAtPath:path];
    [handle seekToEndOfFile];
    [handle writeData:[@" Mobvoi" dataUsingEncoding:NSUTF8StringEncoding]];
    [handle closeFile];
  }
  //  读取文件
  NSString *string = [NSString stringWithContentsOfFile:path
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];
  NSLog(@"Handle %@", string);
}

- (void)archive {
  //  创建对象
  Person *person = [Person new];
  person.name = @"Light";
  person.age = 23;
  //  归档
  NSMutableData *data = [NSMutableData data];
  NSKeyedArchiver *archiver =
      [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
  [archiver encodeObject:person forKey:@"User"];
  [archiver finishEncoding];
  //  写入文件
  [data writeToFile:[self.docPath stringByAppendingPathComponent:@"archiver"]
         atomically:YES];
  //  读出文件
  NSData *data2 = [NSData
      dataWithContentsOfFile:[self.docPath
                                 stringByAppendingPathComponent:@"archiver"]];
  //  解档
  NSKeyedUnarchiver *unArchiver =
      [[NSKeyedUnarchiver alloc] initForReadingWithData:data2];
  Person *person2 = [unArchiver decodeObjectForKey:@"User"];
  [unArchiver finishDecoding];
  //  输出对象
  NSLog(@"name %@", person2.name);
  NSLog(@"age %ld", person2.age);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
