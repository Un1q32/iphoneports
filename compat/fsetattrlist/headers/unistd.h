__BEGIN_DECLS
#ifdef __LP64__
int fsetattrlist(int, void *, void *, size_t, unsigned int);
#else
int fsetattrlist(int, void *, void *, size_t, unsigned long);
#endif
__END_DECLS
