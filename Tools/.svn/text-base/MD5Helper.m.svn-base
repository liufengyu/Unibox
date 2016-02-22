//
//  MD5Helper.m
//  
//
//  Created by on 13-12-6.
//  Copyright (c) 2013年. All rights reserved.
//

#import "MD5Helper.h"
#import "CommonCrypto/CommonDigest.h"

@implementation MD5Helper

+(NSString *)MD5WithString:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //CC_LONG long1 = strlen(cStr);
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
    
}
@end
