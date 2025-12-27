package com.winddown.app.ui.state

import com.winddown.app.data.local.entity.CalmItem

data class ReflectionUiState(
    val calmItems: List<CalmItem> = emptyList(),
    val trustModeEnabled: Boolean = false,
    val isLoading: Boolean = true
)






