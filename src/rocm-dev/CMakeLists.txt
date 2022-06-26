
cmake_minimum_required( VERSION 3.16.3 )

project( rocm-dev LANGUAGES CXX )

set( CMAKE_BUILD_TYPE Release )
set( CMAKE_INSTALL_PREFIX /opt/rocm )

set( PROJECT_VERSION_MAJOR 5 )
set( PROJECT_VERSION_MINOR 1 )
set( PROJECT_VERSION_PATCH 3 )

set( CPACK_PACKAGE_VERSION_MAJOR 5 )
set( CPACK_PACKAGE_VERSION_MINOR 1 )
set( CPACK_PACKAGE_VERSION_PATCH 3 )

set( CPACK_PACKAGE_NAME ${PROJECT_NAME} )
set( CPACK_PACKAGE_VENDOR "Advanced Micro Devices, Inc" )
set( CPACK_DEBIAN_PACKAGE_MAINTAINER amd )
set( CPACK_DEBIAN_PACKAGE_SECTION "devel" )
set( CPACK_PACKAGE_DESCRIPTION_SUMMARY "Radeon Open Compute (ROCm) Runtime software stack" )
set( CPACK_PACKAGE_VERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}.50104-66)
set( CPACK_GENERATOR DEB )
set( CPACK_DEBIAN_PACKAGE_ARCHITECTURE amd64 )
set( CPACK_DEBIAN_PACKAGE_DEPENDS "comgr, hip-base, hip-doc, hip-rocclr, hip-samples, hsakmt-roct, rocm-llvm, rocm-cmake, rocm-dbgapi, rocm-device-libs, rocm-smi-lib, rocm-utils, hsa-rocr-dev, hsakmt-roct-dev, rocprofiler-dev, roctracer-dev" )
set( CPACK_PACKAGING_INSTALL_PREFIX /opt/rocm/ )
set( CPACK_DEBIAN_FILE_NAME "DEB-DEFAULT" )

include( CPack )
