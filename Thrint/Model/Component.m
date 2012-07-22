#import "Component.h"
#import "NSManagedObject+BAAdditions.h"

@implementation Component

+ (NSManagedObject *)insertObject {
    
    Component *component = (Component *)[super insertObject];
    
    component.name = @"New Component";
    
    return component;
}

+ (Component *)insertComponent {
    return (Component *)[self insertObject];
}

@end
