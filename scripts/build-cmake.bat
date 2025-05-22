@echo off

setlocal

:: Check if SolutionDir is already set and non-empty
if not defined SolutionDir (
    :: Only set SolutionDir if it's not already set
    SET "SolutionDir=%~dp0.."
)

:: Ensure the path ends with a backslash
if not "%SolutionDir:~-1%"=="\" SET "SolutionDir=%SolutionDir%\"

cd /d "%SolutionDir%"

cmake -G "Visual Studio 17 2022" -S "%SolutionDir%/" -B "%SolutionDir%build" -A x64 -DCMAKE_INSTALL_PREFIX="%SolutionDir%install" -DCMAKE_MSVC_RUNTIME_LIBRARY="MultiThreaded$<$<CONFIG:Debug>:Debug>" -DCS2SDK_PATH="%SolutionDir%thirdparty/hl2sdk" -DMM_PATH="%SolutionDir%thirdparty/metamod-source"

cmake --build "%SolutionDir%build" --config Release --target install

echo 构建完成！

endlocal