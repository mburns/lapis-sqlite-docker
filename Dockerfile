FROM archlinux:latest

RUN pacman -Sy base-devel lua51 lua52 lua53 lua sqlite postgresql postgresql-libs luarocks redis tup mariadb libmariadbclient mariadb-clients openssl-1.1 git --noconfirm && (yes | pacman -Scc || :)

# setup openresty
ARG OPENRESTY_VERSION="1.21.4.2rc1"
RUN curl -O https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz && \
	tar xvfz openresty-${OPENRESTY_VERSION}.tar.gz && \
	(cd openresty-${OPENRESTY_VERSION} && ./configure --with-pcre-jit --with-cc-opt="-I/usr/include/openssl-1.1" --with-ld-opt="-L/usr/lib/openssl-1.1" && make && make install) && \
	rm -rf openresty-${OPENRESTY_VERSION} && rm openresty-${OPENRESTY_VERSION}.tar.gz

# install lua dependencies
COPY blog-dev-1.rockspec luarocks.lock /
RUN luarocks --lua-version=5.1 build --tree "$HOME/.luarocks" --only-deps /blog-dev-1.rockspec
