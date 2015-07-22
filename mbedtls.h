#ifndef MBEDTLS_H
#define MBEDTLS_H

#define SSL_ERROR_WANT_READ	MBEDTLS_ERR_SSL_WANT_READ
#define SSL_ERROR_WANT_WRITE	MBEDTLS_ERR_SSL_WANT_WRITE
#define SSL_ERROR_ZERO_RETURN	MBEDTLS_ERR_SSL_PEER_CLOSE_NOTIFY

#define SSL_SESSION		mbedtls_ssl_session
#define SSL			mbedtls_ssl_context
#define SSL_CTX			mbedtls_ssl_config

#define SSL_do_handshake	mbedtls_ssl_handshake
#define SSL_read		mbedtls_ssl_read
#define SSL_write		mbedtls_ssl_write
#define SSLeay			mbedtls_version_get_number

#endif /* MBEDTLS_H */
