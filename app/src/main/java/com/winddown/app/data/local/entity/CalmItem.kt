package com.winddown.app.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "calm_items")
data class CalmItem(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val text: String,
    val order: Int,
    val isChecked: Boolean = false
)






