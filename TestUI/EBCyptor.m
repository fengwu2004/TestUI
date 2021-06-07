//
//  EBCypto.m
//  TestUI
//
//  Created by li on 2021/6/7.
//

#import "EBCyptor.h"
#define kRC4CIPERKEY @"23OdsDwesd239sdvlsdDFSD"

@implementation EBCyptor

// RC4加密算法
unsigned char * RC4( unsigned char*  data, int iLen,  const unsigned char* key, unsigned long key_len)
{
    int i=0, j=0, x=0, temp=0;
    int iLenx = iLen+1;
    
    /*分配存储 iLen+1 */
    Byte *outp = (Byte *)malloc(sizeof(Byte) * iLenx);
    memset(outp, 0, iLenx);
    
    /*KSA*/
    int S[256];
    for(i = 0; i < 256; i++) {
        S[i] = (i + 1);
    }
    for(j = i = 0; i < 256; i++) {
        j=( j + key[i%key_len] + S[i] ) % 256;
        temp = S[i];
        S[i] = S[j];
        S[j] = temp;
    }
    
    /*PRGA*/
    for(i = j = x = 0; x < iLen; x++) {
        i = (i + 1) % 256;
        j = (j + S[i]) % 256;
        temp = S[i];
        S[i] = S[j];
        S[j] = temp;
        outp[x] = (unsigned char)(data[x] ^ (S[(S[i] + S[j]) % 256]) );
    }
    outp[iLen]='\0';
    return outp;
}

+ (NSData *)ciperWithRC4:(NSData *)data {
    
    if (!data) {
        
        return nil;
    }
    
    if (data.length <= 0) {
        
        return data;
    }
    
    const char *key = kRC4CIPERKEY.UTF8String;
    
    NSInteger keyLength = strlen(key);
    
    unsigned char *result = RC4((unsigned char*)data.bytes, (int)data.length, (const unsigned char*)key, keyLength);
    
    NSData *outputData = [NSData dataWithBytes:result length:data.length];
    
    return outputData;
}

+ (NSData *)deciperWithRC4:(NSData *)data {
    
    return [self ciperWithRC4:data];;
}

@end
