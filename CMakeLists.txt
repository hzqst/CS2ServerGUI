cmake_minimum_required(VERSION 3.20)
project(CS2ServerGUI)

# 设置C++标准
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 设置输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# 添加编译选项
if(MSVC)
    add_compile_options(/W4)
    add_definitions(
        -DCOMPILER_MSVC
        -DCOMPILER_MSVC64
        -DPLATFORM_64BITS
        -DX64BITS
        -DWIN32
        -DWINDOWS
        -DCRT_SECURE_NO_WARNINGS
        -DCRT_SECURE_NO_DEPRECATE
        -DCRT_NONSTDC_NO_DEPRECATE
        -D_MBCS
        -DMETA_IS_SOURCE2
    )
endif()

# 设置SDK路径选项
option(CS2SDK_PATH "Path to CS2 SDK" "")
option(MM_PATH "Path to Metamod Source" "")

if(NOT CS2SDK_PATH)
    message(FATAL_ERROR "CS2SDK_PATH must be set. Use -DCS2SDK_PATH=<path> when running cmake")
endif()

if(NOT MM_PATH)
    message(FATAL_ERROR "MM_PATH must be set. Use -DMM_PATH=<path> when running cmake")
endif()

# 规范化路径
file(REAL_PATH "${CS2SDK_PATH}" CS2SDK_PATH)
file(REAL_PATH "${MM_PATH}" MM_PATH)

message(STATUS "CS2SDK_PATH: ${CS2SDK_PATH}")
message(STATUS "MM_PATH: ${MM_PATH}")

# 添加源文件
file(GLOB_RECURSE SOURCES "src/*.cpp")
file(GLOB_RECURSE HEADERS "src/*.h")

# 添加SDK源文件
set(SDK_SOURCES
    ${CS2SDK_PATH}/tier1/convar.cpp
    ${CS2SDK_PATH}/public/tier0/memoverride.cpp
    ${CS2SDK_PATH}/tier1/generichash.cpp
    ${CS2SDK_PATH}/entity2/entitysystem.cpp
    ${CS2SDK_PATH}/entity2/entityidentity.cpp
    ${CS2SDK_PATH}/entity2/entitykeyvalues.cpp
    ${CS2SDK_PATH}/tier1/keyvalues3.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/src/extension.cpp
)

# 添加protobuf源文件
set(PROTOBUF_SOURCES
    protobufs/generated/usermessages.pb.cc
    protobufs/generated/network_connection.pb.cc
    protobufs/generated/networkbasetypes.pb.cc
    protobufs/generated/engine_gcmessages.pb.cc
    protobufs/generated/steammessages.pb.cc
    protobufs/generated/gcsdk_gcmessages.pb.cc
    protobufs/generated/cstrike15_gcmessages.pb.cc
    protobufs/generated/cstrike15_usermessages.pb.cc
    protobufs/generated/usercmd.pb.cc
    protobufs/generated/cs_usercmd.pb.cc
)

# 创建共享库目标
add_library(CS2ServerGUI SHARED
    ${SOURCES}
    ${HEADERS}
    ${SDK_SOURCES}
    ${PROTOBUF_SOURCES}
)

# 添加包含目录
target_include_directories(CS2ServerGUI PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    #${CMAKE_CURRENT_SOURCE_DIR}/vendor/funchook/include
    ${CMAKE_CURRENT_SOURCE_DIR}/vendor
    ${CS2SDK_PATH}
    ${CS2SDK_PATH}/thirdparty/protobuf-3.21.8/src
    ${CS2SDK_PATH}/common
    ${CS2SDK_PATH}/game/shared
    ${CS2SDK_PATH}/game/server
    ${CS2SDK_PATH}/public
    ${CS2SDK_PATH}/public/engine
    ${CS2SDK_PATH}/public/mathlib
    ${CS2SDK_PATH}/public/tier0
    ${CS2SDK_PATH}/public/tier1
    ${CS2SDK_PATH}/public/entity2
    ${CS2SDK_PATH}/public/game/server
    ${MM_PATH}/core
    ${MM_PATH}/core/sourcehook
    ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/imgui
    ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/imgui/backends
    ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/ImGuiFileDialog
    ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/nlohmann_json/include
)

# 链接库
target_link_libraries(CS2ServerGUI PRIVATE
    ${CS2SDK_PATH}/lib/public/win64/2015/libprotobuf.lib
    ${CS2SDK_PATH}/lib/public/win64/tier0.lib
    ${CS2SDK_PATH}/lib/public/win64/tier1.lib
    ${CS2SDK_PATH}/lib/public/win64/interfaces.lib
    ${CS2SDK_PATH}/lib/public/win64/mathlib.lib
    #${CMAKE_CURRENT_SOURCE_DIR}/vendor/funchook/lib/Release/distorm.lib
    #${CMAKE_CURRENT_SOURCE_DIR}/vendor/funchook/lib/Release/funchook.lib
    d3d9
    psapi
)

# 添加ImGui源文件
target_sources(CS2ServerGUI PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/imgui/imgui.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/imgui/imgui_demo.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/imgui/imgui_draw.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/imgui/imgui_tables.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/imgui/imgui_widgets.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/imgui/backends/imgui_impl_dx9.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/imgui/backends/imgui_impl_win32.cpp
)

# 添加ImGuiFileDialog源文件
file(GLOB_RECURSE IMGUI_FILE_DIALOG_SOURCES 
    "${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/ImGuiFileDialog/*.cpp"
)
target_sources(CS2ServerGUI PRIVATE ${IMGUI_FILE_DIALOG_SOURCES}) 