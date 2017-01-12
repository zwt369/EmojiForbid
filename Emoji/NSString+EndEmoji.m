//
//  NSString+EndEmoji.m
//  Emoji
//
//  Created by 百变家装002 on 17/1/12.
//  Copyright © 2017年 百变家装002. All rights reserved.
//

#import "NSString+EndEmoji.h"

 #define MULITTHREEBYTEUTF16TOUNICODE(x,y) (((((x ^ 0xD800) << 2) | ((y ^ 0xDC00) >> 8)) << 8) | ((y ^ 0xDC00) & 0xFF)) + 0x10000

@implementation NSString (EndEmoji)


-(BOOL)textIsEmojiOrNot{
    
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }else if (0x1f910 <= uc && uc <= 0x1f917 ){
                     returnValue = YES;
                 }else if (0x1f980 <= uc && uc <= 0x1f987){
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             
             const unichar ls = [substring characterAtIndex:1];
             const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
             if (ls == 0x20e3  || ls == 0xFE0F || ls == 0xd83c) {
                 returnValue = YES;
             }
            if (uc == 0x3f9ea0f || uc == 0x3f9e60f){
                 returnValue = YES;
            }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff)
             {
                 if (0x278b <= hs && 0x2792 >= hs)
                 {
                     returnValue = NO;
                 }
                 else
                 {
                     returnValue = YES;
                 }
             }
             else if (0x2B05 <= hs && hs <= 0x2b07)
             {
                 returnValue = YES;
             }
             else if (0x2934 <= hs && hs <= 0x2935)
             {
                 returnValue = YES;
             }
             else if (0x3297 <= hs && hs <= 0x3299)
             {
                 returnValue = YES;
             }
             else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50 || hs == 0xd83e)
             {
                 returnValue = YES;
             }
         }
     }];
    
    
    
    return returnValue;
}

-(NSString *)transEmojiToUnicode{
    NSString *hexstr = @"";
    
    for (int i=0;i< [self length];i++)
    {
        hexstr = [hexstr stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"0x%1X ",[self characterAtIndex:i]]];
    }
    NSLog(@"UTF16 [%@]",hexstr);
    
    hexstr = @"";
    
    int slen = (int)strlen([self UTF8String]);
    
    for (int i = 0; i < slen; i++)
    {
        //fffffff0 去除前面六个F & 0xFF
        hexstr = [hexstr stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"0x%X ",[self UTF8String][i] & 0xFF ]];
    }
    NSLog(@"UTF8 [%@]",hexstr);
    
    hexstr = @"";
    
    if ([self length] >= 2) {
        
        for (int i = 0; i < [self length] / 2 && ([self length] % 2 == 0) ; i++)
        {
            // three bytes
            if (([self characterAtIndex:i*2] & 0xFF00) == 0 ) {
                hexstr = [hexstr stringByAppendingFormat:@"Ox%1X 0x%1X",[self characterAtIndex:i*2],[self characterAtIndex:i*2+1]];
            }
            else
            {// four bytes
                hexstr = [hexstr stringByAppendingFormat:@"U+%1X ",MULITTHREEBYTEUTF16TOUNICODE([self characterAtIndex:i*2],[self characterAtIndex:i*2+1])];
            }
            
        }
        NSLog(@"(unicode) [%@]",hexstr);
        return hexstr;
    }
    else
    {
        NSLog(@"(unicode) U+%1X",[self characterAtIndex:0]);
        return @"";
    }
}

@end
