# 设置
set -e
BT_ROOT="/opt/Baltamatica"
deb_file=$(ls baltamatica_*.deb)
license_file="/mnt/c/baltamatica/licenses/LICENSE"

echo "=== 安装，需要 cd 到 deb 所在目录 ==="
if [ -d "$BT_ROOT" ]; then
    echo "$BT_ROOT 已存在！"
	exit
fi
sudo apt update
sudo apt purge baltamatica -y
sudo apt install "./$deb_file" -y

echo "=== 记录版本号 ==="
cd "$BT_ROOT"
touch "$BT_ROOT/$(basename "$deb_file" .deb)"

echo "=== 备份要更新的文件夹 ==="
cp -r lib lib-original
cp -r plugins/{Python,Python-original}
cp -r plugins/{SymPy,SymPy-original}
cp -r toolbox/{CodeGeneration,CodeGeneration-original}
cp -r external/python/{python3.12.7,python3.12.7-original}

echo "=== 隐藏工具箱（不需要隐藏插件，不会默认加载） ==="
mkdir toolbox/hide
mv toolbox/{*,hide} > /dev/null 2>&1
mv toolbox/hide/CodeGeneration toolbox

echo "=== LICENSE ==="
if [ -f "$license_file" ]; then
	echo "警告：[$license_file] 不存在，请手动复制"
	exit
fi
cp "$license_file" licenses/
