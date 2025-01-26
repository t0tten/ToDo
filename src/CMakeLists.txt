add_executable(todor)

ecm_add_qml_module(todor
    URI
    org.example.todor
)

target_sources(todor
    PRIVATE
    main.cpp
)

ecm_target_qml_sources(todor
    SOURCES
    Main.qml
)

target_link_libraries(todor
    PRIVATE
    Qt6::Quick
    Qt6::Qml
    Qt6::Gui
    Qt6::QuickControls2
    Qt6::Widgets
    KF6::I18n
    KF6::CoreAddons
    KF6::IconThemes
    todor-components
)

install(TARGETS todor ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

add_subdirectory(components)
