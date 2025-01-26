add_library(todor-components)

ecm_add_qml_module(todor-components
    URI "org.example.todor.components"
    GENERATE_PLUGIN_SOURCE
)

ecm_target_qml_sources(todor-components
    SOURCES
    ItemsList.qml
)

ecm_finalize_qml_module(todor-components)

install(TARGETS todor-components ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
