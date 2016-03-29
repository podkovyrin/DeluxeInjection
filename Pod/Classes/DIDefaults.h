//
//  DIDefaults.h
//  Pods
//
//  Created by Anton Bukov on 27.03.16.
//
//

#import "DeluxeInjectionImpl.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DIDefaults <NSObject>

@end

@protocol DIDefaultsSync <NSObject>

@end

@interface NSObject (DIDefaults) <DIDefaults, DIDefaultsSync>

@end

/**
 *  Block to define custom key for properties to store in NSUserDefaults
 *
 *  @param targetClass       Class to be injected/rejected
 *  @param propertyName      Property name to be injected/rejected
 *  @param propertyClass     Class of property to be injected/rejected, at least \c NSObject
 *  @param propertyProtocols Set of property protocols including all superprotocols
 *
 *  @return Key to store in \c NSUserDefaults for propertyName of \c targetClass or \c nil to use \c propertyName
 */
typedef NSString * _Nullable (^DIDefaultsKeyBlock)(Class targetClass, NSString *propertyName, Class propertyClass, NSSet<Protocol *> *propertyProtocols);

@interface DeluxeInjection (DIDefaults)

/**
 *  Inject properties marked with \c <DIDefaults> and \c <DIDefaultsSync> protocol using NSUserDefaults access
 */
+ (void)injectDefaults;

/**
 *  Inject properties marked with \c <DIDefaults> and \c <DIDefaultsSync> protocol
 *  using NSUserDefaults access with custom key provided by block
 */
+ (void)injectDefaultsWithKey:(DIDefaultsKeyBlock)keyBlock;

/**
 *  Reject all injections marked explicitly with \c <DIDefaults> and \c <DIDefaultsSync> protocol.
 */
+ (void)rejectDefaults;

@end

NS_ASSUME_NONNULL_END