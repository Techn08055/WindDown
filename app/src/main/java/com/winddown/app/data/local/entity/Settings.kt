package com.winddown.app.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "settings")
data class Settings(
    @PrimaryKey
    val id: Int = 1,
    val bedtimeHour: Int = 22, // 10 PM
    val bedtimeMinute: Int = 30,
    val trustModeEnabled: Boolean = false,
    val completedToday: Boolean = false,
    val completionTime: String? = null,
    val lastCompletionDate: String? = null
)






