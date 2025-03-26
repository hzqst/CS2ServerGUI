@echo off
setlocal enabledelayedexpansion

:: 创建deps目录
if not exist deps mkdir deps
cd deps

:: 克隆 Metamod:Source
echo 正在克隆 Metamod:Source...
if not exist metamod-source (
    git clone --recursive https://github.com/alliedmodders/metamod-source.git
    cd metamod-source
    git checkout master
    cd ..
)

:: 克隆 HL2SDK CS2
echo 正在克隆 HL2SDK CS2...
if not exist hl2sdk (
    git clone --recursive https://github.com/alliedmodders/hl2sdk.git
    cd hl2sdk
    git checkout cs2
    cd ..
)

:: 设置环境变量
set "MMSOURCE112=%CD%\metamod-source"
set "HL2SDKCS2=%CD%\hl2sdk"

:: 创建xmake包目录结构
echo 正在设置xmake包目录...
if exist imgui-v1.91.1.7z (
    if not exist "packages\i\imgui\1.91.1" mkdir "packages\i\imgui\1.91.1"
    copy /Y imgui-v1.91.1.7z "packages\i\imgui\1.91.1\"
)

:: 返回项目根目录
cd ..

:: 检查并修改 commonmacros.h
echo 正在检查并修改 commonmacros.h...
set "MACRO_FILE=deps\hl2sdk\public\tier0\commonmacros.h"
if exist "%MACRO_FILE%" (
    powershell -Command "$content = Get-Content '%MACRO_FILE%' -Raw; if ($content -match '#define Q_ARRAYSIZE\(p\)\s*ARRAYSIZE\(p\)') { $content = $content -replace '#define Q_ARRAYSIZE\(p\)\s*ARRAYSIZE\(p\)', '#define Q_ARRAYSIZE(p)		RTL_NUMBER_OF_V2(p)'; Set-Content '%MACRO_FILE%' $content; Write-Host '已修改 Q_ARRAYSIZE 定义' }"
    powershell -Command "$content = Get-Content '%MACRO_FILE%' -Raw; if ($content -match '#define V_ARRAYSIZE\(p\)\s*ARRAYSIZE\(p\)') { $content = $content -replace '#define V_ARRAYSIZE\(p\)\s*ARRAYSIZE\(p\)', '#define V_ARRAYSIZE(p)		RTL_NUMBER_OF_V1(p)'; Set-Content '%MACRO_FILE%' $content; Write-Host '已修改 V_ARRAYSIZE 定义' }"
)

:: 使用xmake构建
echo 正在构建项目...
xmake f -p windows -a x64 -m release --pkg_searchdirs=deps/packages --includedirs="deps/hl2sdk/public" --includedirs="deps/hl2sdk/public/tier0" --includedirs="deps/hl2sdk/public/tier1"
xmake

echo 构建完成！
pause 