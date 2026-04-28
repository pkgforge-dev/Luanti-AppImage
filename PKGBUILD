# Maintainer: Laurent Carlier <lordheavym@gmail.com>
# Contributor: Konsta Kokkinen <kray@tsundere.fi>

pkgname=('luanti' 'luanti-server' 'luanti-common')
pkgver=5.15.2
pkgrel=1
arch=('x86_64')
url='https://www.luanti.org/'
license=(LGPL-2.1-or-later)
makedepends=('sqlite' 'freetype2' 'leveldb' 'postgresql' 'libspatialindex' 'openal' 'libvorbis' 'curl'
             'hicolor-icon-theme' 'cmake' 'ninja' 'hiredis' 'luajit' 'sdl2')
makedepends+=('libjpeg-turbo' 'libgl' 'libxi' 'git')
source=(${pkgname}-${pkgver}.tar.gz::https://github.com/minetest/minetest/archive/${pkgver}.tar.gz
        luanti.service
        sysusers.d
        tmpfiles.d)
sha256sums=('fe0b10df866f57c0047d84a4c6f6cd848650f52d9b0cab563fbbedc81632d616'
            'f2614e89c620daccd641b8b047302e73509b78b510631757cf7fa0a332b8f7e7'
            '294283b0686c4d73d816168544ab2f813a7a0ca63fc49da59563a329dd329eed'
            'c9a0c78a49461f56381e5615045d036cd594b741c910129eccf43e475c40cca1')

prepare() {
  install -d build-{client,server}
}

build() {
  cd build-client
  cmake -G Ninja ../luanti-${pkgver} \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DBUILD_CLIENT=1 \
    -DENABLE_GETTEXT=1 \
    -DENABLE_LEVELDB=0 \
    -DENABLE_POSTGRESQL=1 \
    -DENABLE_SPATIAL=1 \
    -DENABLE_REDIS=0
  ninja

  cd ../build-server
  cmake -G Ninja ../luanti-${pkgver} \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DBUILD_CLIENT=0 \
    -DBUILD_SERVER=1 \
    -DENABLE_LEVELDB=1 \
    -DENABLE_POSTGRESQL=1 \
    -DENABLE_SPATIAL=1 \
    -DENABLE_REDIS=1
  ninja
}

package_luanti() {
  pkgdesc='Multiplayer infinite-world block sandbox game'
  depends=('luanti-common' 'curl' 'libvorbis' 'sqlite'
           'openal' 'hicolor-icon-theme' 'desktop-file-utils' 'xdg-utils'
           'freetype2' 'luajit' 'postgresql-libs' 'spatialindex' 'jsoncpp'
           'libgl' 'libjpeg-turbo' 'libxi') # irrlichtmt
  conflicts=('minetest')
  replaces=('minetest')

  cd build-client
  DESTDIR="${pkgdir}" ninja install

  rm -rf "${pkgdir}"/usr/share/{luanti,doc}
  rm "${pkgdir}"/usr/share/man/man6/luantiserver.6
}

package_luanti-server() {
  pkgdesc='Server of infinite-world block sandbox game'
  depends=('luanti-common' 'leveldb' 'curl' 'sqlite' 'hiredis' 'luajit'
           'postgresql-libs' 'spatialindex' 'jsoncpp')
  conflicts=('minetest-server')
  replaces=('minetest-server')

  cd build-server
  DESTDIR="${pkgdir}" ninja install
  install -d  "${pkgdir}"/etc/luanti
  install -Dm644 ../luanti.service \
    "${pkgdir}"/usr/lib/systemd/system/luanti@.service

  rm -rf "${pkgdir}"/usr/share/{luanti,metainfo,appdata,applications,icons,doc}
  mv "${pkgdir}"/usr/share/man/man6/luanti.6 "${pkgdir}"/usr/share/man/man6/luantiserver.6

  install -Dm644 "${srcdir}"/tmpfiles.d "${pkgdir}"/usr/lib/tmpfiles.d/luanti-server.conf
  install -Dm644 "${srcdir}"/sysusers.d "${pkgdir}"/usr/lib/sysusers.d/luanti-server.conf
}

package_luanti-common() {
  pkgdesc='Common data files for luanti and luanti-server'
  license=('custom')
  conflicts=('minetest-common')
  replaces=('minetest-common')

  cd luanti-${pkgver}
  install -d "${pkgdir}"/usr/share/luanti

  cp -r builtin client fonts textures "${pkgdir}"/usr/share/luanti/
  cp -r "${srcdir}"/build-client/locale "${pkgdir}"/usr/share/luanti/

  for file in doc/{fst_api,lua_api,menu_lua_api,protocol,world_format}.*; do
    install -Dm644 $file "${pkgdir}"/usr/share/luanti/doc/$(basename $file)
  done

  install -Dm644 LICENSE.txt "${pkgdir}"/usr/share/licenses/${pkgname}/LICENSE.txt
}
