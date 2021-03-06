// RUN: %clang_cc1 -verify %s

void f(void);
void f(void) __asm__("fish");
void g(void);

void f(void) {
  g();
}
void g(void) __asm__("gold");  // expected-error{{cannot apply asm label to function after its first use}}

void h(void) __asm__("hose");  // expected-note{{previous declaration is here}}
void h(void) __asm__("hair");  // expected-error{{conflicting asm label}}

int x;
int x __asm__("xenon");
int y;

int test(void) { return y; }

int y __asm__("yacht");  // expected-error{{cannot apply asm label to variable after its first use}}

int z __asm__("zebra");  // expected-note{{previous declaration is here}}
int z __asm__("zooms");  // expected-error{{conflicting asm label}}


// No diagnostics on the following.
void __real_readlink(void) __asm("readlink");
void readlink(void) __asm("__protected_readlink");
void readlink(void) { __real_readlink(); }
