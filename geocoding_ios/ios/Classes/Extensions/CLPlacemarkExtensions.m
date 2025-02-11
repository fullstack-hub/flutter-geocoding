//
//  CLPlacemarkExtensions.m
//  geocoding
//
//  Created by Maurits van Beusekom on 07/06/2020.
//

#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import "CLPlacemarkExtensions.h"

@implementation CLPlacemark (CLPlacemarkExtensions)

- (NSDictionary *)toPlacemarkDictionary {
    NSString* street = @"";

    if (self.postalAddress != nil) {
        street = self.postalAddress.street;
    }

    NSString* formattedAddress = @"";
    if (@available(iOS 11.0, *)) {
        if (self.postalAddress != nil) {
            CNPostalAddressFormatter *formatter = [[CNPostalAddressFormatter alloc] init];
            formattedAddress = [formatter stringFromPostalAddress:self.postalAddress];
            
            // 🔹 줄바꿈("\n")을 공백(" ")으로 변환하여 한 줄 주소로 변환
            formattedAddress = [formattedAddress stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            
            // 🔹 국가명 자동 제거 (self.postalAddress.country 사용)
            if (self.postalAddress.country != nil && [formattedAddress hasPrefix:self.postalAddress.country]) {
                formattedAddress = [formattedAddress stringByReplacingOccurrencesOfString:self.postalAddress.country withString:@""];
                formattedAddress = [formattedAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
        }
    }

    NSMutableDictionary<NSString *, NSObject *> *dict = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"name": self.name == nil ? @"" : self.name,
        @"street": street == nil ? @"" : street,
        @"isoCountryCode": self.ISOcountryCode == nil ? @"" : self.ISOcountryCode,
        @"country": self.country == nil ? @"" : self.country,
        @"thoroughfare": self.thoroughfare == nil ? @"" : self.thoroughfare,
        @"subThoroughfare": self.subThoroughfare == nil ? @"" : self.subThoroughfare,
        @"postalCode": self.postalCode == nil ? @"" : self.postalCode,
        @"administrativeArea": self.administrativeArea == nil ? @"" : self.administrativeArea,
        @"subAdministrativeArea": self.subAdministrativeArea == nil ? @"" : self.subAdministrativeArea,
        @"locality": self.locality == nil ? @"" : self.locality,
        @"subLocality": self.subLocality == nil ? @"" : self.subLocality,
        @"formattedAddress": formattedAddress == nil ? @"" : formattedAddress,
    }];

    return dict;
}

- (NSDictionary *)toLocationDictionary {
    if (self.location == nil) {
        return nil;
    }
    
    NSMutableDictionary<NSString *, NSObject*> *dict = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"latitude": @(self.location.coordinate.latitude),
        @"longitude": @(self.location.coordinate.longitude),
        @"timestamp": @([CLPlacemark currentTimeInMilliSeconds: self.location.timestamp]),
    }];
    
    return dict;
}

+ (double)currentTimeInMilliSeconds:(NSDate *)dateToConvert {
    NSTimeInterval since1970 = [dateToConvert timeIntervalSince1970];
    return since1970 * 1000;
}

@end
