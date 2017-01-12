//
//  NSString+EndEmoji.h
//  Emoji
//
//  Created by 百变家装002 on 17/1/12.
//  Copyright © 2017年 百变家装002. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EndEmoji)

-(BOOL)textIsEmojiOrNot;

-(NSString *)transEmojiToUnicode;

@end
