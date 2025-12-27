package com.winddown.app.ui.state

import com.winddown.app.data.local.entity.CalmItem

data class SettingsUiState(
    val bedtimeHour: Int = 22,
    val bedtimeMinute: Int = 30,
    val trustModeEnabled: Boolean = false,
    val calmItems: List<CalmItem> = emptyList(),
    val newItemText: String = "",
    val isLoading: Boolean = true
)






