__BEGIN_DECLS
int getservbyport_r(int, const char *, struct servent *, char *, size_t,
                    struct servent **);
__END_DECLS
