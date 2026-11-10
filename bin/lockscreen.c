#include <dlfcn.h>
int main(void) {
    void *h = dlopen("/System/Library/PrivateFrameworks/login.framework/login", RTLD_LAZY);
    if (!h) return 1;
    int (*lock)(void) = dlsym(h, "SACLockScreenImmediate");
    if (!lock) return 2;
    return lock();
}
