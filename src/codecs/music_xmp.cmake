option(USE_XMP         "Build with XMP library" ON)
if(USE_XMP)
    option(USE_XMP_DYNAMIC "Use dynamical loading of XMP library" OFF)

    if(USE_SYSTEM_AUDIO_LIBRARIES)
        find_package(XMP)
        message("XMP: [${XMP_FOUND}] ${XMP_INCLUDE_DIRS} ${XMP_LIBRARIES}")
        if(USE_XMP_DYNAMIC)
            add_definitions(-DXMP_DYNAMIC=\"${XMP_DYNAMIC_LIBRARY}\")
            message("Dynamic XMP: ${XMP_DYNAMIC_LIBRARY}")
        endif()
    else()
        if(WIN32)
            add_definitions(-DBUILDING_STATIC)
        endif()
        if(DOWNLOAD_AUDIO_CODECS_DEPENDENCY)
            set(XMP_LIBRARIES xmp)
        else()
            find_library(XMP_LIBRARIES NAMES xmp
                         HINTS "${AUDIO_CODECS_INSTALL_PATH}/lib")
        endif()
        set(XMP_FOUND 1)
        set(XMP_INCLUDE_DIRS
            ${AUDIO_CODECS_PATH}/libxmp/include
            ${AUDIO_CODECS_INSTALL_PATH}/include/xmp
        )
    endif()

    if(XMP_FOUND)
        message("== using libXMP ==")
        add_definitions(-DMUSIC_MOD_XMP)
        list(APPEND SDL_MIXER_INCLUDE_PATHS ${XMP_INCLUDE_DIRS})
        if(NOT USE_SYSTEM_AUDIO_LIBRARIES OR NOT USE_XMP_DYNAMIC)
            list(APPEND SDLMixerX_LINK_LIBS ${XMP_LIBRARIES})
        endif()
        list(APPEND SDLMixerX_SOURCES ${CMAKE_CURRENT_LIST_DIR}/music_xmp.c)
    else()
        message("-- skipping XMP --")
    endif()
endif()
