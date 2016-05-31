//
//  DIInject.m
//  DeluxeInjection
//
//  Copyright (c) 2016 Anton Bukov <k06aaa@gmail.com>
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://opensource.org/licenses/MIT
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <RuntimeRoutines/RuntimeRoutines.h>

#import "DIDeluxeInjectionPlugin.h"
#import "DIImperative.h"

#import "DIInject.h"

@implementation DeluxeInjection (DIInject)

+ (void)load {
    [DIImperative registerPluginProtocol:@protocol(DIInject)];
}

+ (void)inject:(DIPropertyGetter)block {
    [self inject:^NSArray * (Class targetClass, SEL getter, SEL setter, NSString *propertyName, Class propertyClass, NSSet<Protocol *> *propertyProtocols) {
        id value = block(targetClass, getter, propertyName, propertyClass, propertyProtocols);
        if (value == [DeluxeInjection doNotInject]) {
            return nil;
        }
        
        objc_property_t property = RRClassGetPropertyByName(targetClass, propertyName);
        if (RRPropertyGetIsWeak(property)) {
            __weak id weakValue = value;
            return @[DIGetterIfIvarIsNil(^id(id target) {
                return weakValue;
            }), [DeluxeInjection doNotInject]];
        } else {
            return @[DIGetterIfIvarIsNil(^id(id target) {
                return value;
            }), [DeluxeInjection doNotInject]];
        }
    } conformingProtocols:@[@protocol(DIInject)]];
}

+ (void)injectBlock:(DIPropertyGetterBlock)block {
    [self inject:^NSArray *(Class targetClass, SEL getter, SEL setter, NSString *propertyName, Class propertyClass, NSSet<Protocol *> *propertyProtocols) {
        return @[(id)block(targetClass, getter, propertyName, propertyClass, propertyProtocols) ?: (id)[DeluxeInjection doNotInject], [DeluxeInjection doNotInject]];
    } conformingProtocols:@[@protocol(DIInject)]];
}

+ (void)reject:(DIPropertyFilter)block {
    [self reject:block conformingProtocols:@[@protocol(DIInject)]];
}

+ (void)rejectAll {
    [self reject:^BOOL(Class targetClass, NSString *propertyName, Class propertyClass, NSSet<Protocol *> *propertyProtocols) {
        return YES;
    } conformingProtocols:@[@protocol(DIInject)]];
}

@end
