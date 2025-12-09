# mac 安装北太天元并自动记录版本和备份关键文件夹
# 设置
set -e
BT_ROOT="/Applications/Baltamatica.app/Contents"
zip_file=$(ls baltamatica_*.zip)
license_file="LICENSE"

echo "=== 安装，需要 cd 到 zip 所在目录 ==="
if [ -d "$BT_ROOT" ]; then
    echo "$BT_ROOT 已存在！"
    exit
fi
unzip -q "./$zip_file"
sudo mv Baltamatica.app /Applications/

echo "=== 记录版本号 ==="
cd "$BT_ROOT"
touch "$BT_ROOT/$(basename "$zip_file" .zip)"

echo "=== 备份要更新的文件夹 ==="
cp -r Frameworks Frameworks-original
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
