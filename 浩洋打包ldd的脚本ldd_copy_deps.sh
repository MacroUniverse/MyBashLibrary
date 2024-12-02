#!/usr/bin/env bash

if [ -z $SHOW_DEPS ]; then
    SHOW_DEPS=0
fi

if [ -z $OS ]; then
    OS=XNIX
fi

if [ -z $SETUP_DIR ]; then
    echo "No SETUP_DIR given."
    exit 1
fi

DESTDIR=$SETUP_DIR/lib

case $OS in
    XNIX)
        SOEXT=so
        ;;
    MACOS)
        SOEXT=dylib
        ;;
    MSYS)
        SOEXT=dll
        PATH=$PATH:$(cygpath -u ${SETUP_DIR}/lib)
        ;;
    *)
        echo "Unknown OS"
        exit 1
esac

# 移除和 wayland 相关的插件
rm -rf ${SETUP_DIR}/qtplugins/wayland-* ${SETUP_DIR}/qtplugins/platforms/libqwayland-*

deplistfile_orig=$(mktemp);
deplistfile=$(mktemp);
for i in $( ls -1 ${SETUP_DIR}/bin/* ${SETUP_DIR}/lib/*.exe ${SETUP_DIR}/lib/*.${SOEXT} ${SETUP_DIR}/plugins/*/*.${SOEXT} ${SETUP_DIR}/qtplugins/*/*.${SOEXT} ) $(find ${SETUP_DIR}/qml -name "*.${SOEXT}"); do
    if [ ${OS} == "MACOS" ]; then
        otool -L -X ${i} | awk  '{if (match($1,"/")){ print $1 } }' >> $deplistfile_orig
    else
        ldd ${i} | awk  '{if (match($3,"/")){ print $3 } }' >> $deplistfile_orig
    fi
done
cat ${deplistfile_orig} | sort | uniq > $deplistfile

if [ ${OS} == "MSYS" ]; then
    deplist=$( cat ${deplistfile} | grep -i -v "/WINDOWS/" )
elif [ ${OS} == "XNIX" ]; then
    # 不要复制 glibc 中的库，防止 host 与编译平台不一样引发冲突
    # 不要复制 xcb、drm、GL 等库，可能与硬件相关导致无法运行，但要保留 xcb-xinerama、xcb-utils
    # 单独处理 libstdc++、libgcc_s、libz
    deplist=$( cat ${deplistfile} | grep -P -v 'libc\.so|libm\.so|libpthread\.so|libdl\.so|librt\.so|libxcb\.so|libxcb-(?!xinerama|xinput|util\.so)|libdrm\.so|libX|libstdc\+\+|libgcc_s|libz\.so|libGL\.so|libglapi\.so|libGLX\.so|libGLdispatch\.so')
    deplist_cxx=$( cat ${deplistfile} | grep "libstdc++\|libgcc_s")
    deplist_z=$( cat ${deplistfile} | grep "libz\.so")
elif [ ${OS} == "MACOS" ]; then
    deplist=$( cat ${deplistfile} | grep -i -v "@rpath\|libSystem\|libc++\|libz")
fi

if [ ${OS} == "MACOS" ]; then
    cp -f $deplist ${DESTDIR} 2> /dev/null
    rpath_deplist=$( cat ${deplistfile} | sort | uniq | grep -i "@rpath" | grep -i -v "libbt_\|libbex\|libregisterLib\|libMatTool\|main.dylib\|libBxViewBase")
    if [ $SHOW_DEPS == "1" ]; then
        if ! [ -z "$rpath_deplist" ]; then
            echo "以下的库是依赖项，但脚本无法自动进行复制，需要手动复制到安装目录中："
            echo $rpath_deplist
        fi
    fi
else
    cp -u $deplist ${DESTDIR}
    if ! [ -z "$deplist_cxx" ]; then
        mkdir -p ${DESTDIR}/c++
        cp -u $deplist_cxx ${DESTDIR}/c++
    fi
    if ! [ -z "$deplist_z" ]; then
        mkdir -p ${DESTDIR}/zlib
        cp -u $deplist_z ${DESTDIR}/zlib
    fi
fi
#rm ${deplistfile} ${deplistfile_orig}

