# 设置
set -e

BT_ROOT="/c/baltamatica"
exe_file=(baltamatica_*.exe)
license_file="/c/baltamatica_*/licenses/LICENSE"

echo "=== 记录版本号 ==="
cd "$BT_ROOT"
touch "$(basename "$exe_file" .exe)"

echo "=== 备份要更新的文件夹 ==="
cp -r lib lib-original
cp -r plugins/{Python,Python-original}
cp -r plugins/{SymPy,SymPy-original}
cp -r toolbox/{CodeGeneration,CodeGeneration-original}
cp -r external/python/{python3.12.7,python3.12.7-original}

echo "=== 隐藏工具箱（不需要隐藏插件，不会默认加载） ==="
mkdir toolbox/hide
mv toolbox/{*,hide} &> /dev/null
mv toolbox/hide/CodeGeneration toolbox

echo "=== LICENSE ==="
if [ -f "$license_file" ]; then
	echo "警告：[$license_file] 不存在，请手动复制"
	exit
fi
cp "$license_file" licenses/
